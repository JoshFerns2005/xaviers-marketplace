import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:xaviers_market/customerscreens/phonepe.dart';

class Cart extends StatefulWidget {
  final String userId;
  List<QueryDocumentSnapshot<Object?>>? productsList;

  Cart(this.userId);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isCheckingOut = false;
  Map<String, int> quantities = {};

  Future<void> checkout(
      String stallName,
      double totalAmount,
      List<QueryDocumentSnapshot<Object?>> products,
      QueryDocumentSnapshot<Object?> cartDoc) async {
    setState(() {
      _isCheckingOut = true;
    });

    // Set isBooked to true and store the checkout time in the cartDoc
    var checkoutTime = DateTime.now().millisecondsSinceEpoch;
    await cartDoc.reference.update({
      'isBooked': true,
      'checkoutTime': checkoutTime,
      'stallName': stallName,
      'totalAmount': totalAmount
    });

    for (var product in products) {
      var productId = product.id;
      var quantity = quantities[productId];
      await cartDoc.reference.collection('products').doc(productId).update({
        'quantity': quantity,
      });
    }

    // Retrieve the value of 'userId' from the 'stalls/cartDoc.id' document
    var sellerIdSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('carts')
        .doc(cartDoc.id)
        .get();
    var sellerId = sellerIdSnapshot['sellerId'];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .collection('bookings')
        .doc(widget.userId)
        .set({});

    // Start a timer to set isBooked back to false after 15 minutes
    Timer(Duration(minutes: 15), () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var freshCartDoc = await transaction.get(cartDoc.reference);
        if (freshCartDoc.exists) {
          var checkoutTimeInMillis = freshCartDoc['checkoutTime'];
          var fifteenMinutesInMillis = 15 * 60 * 1000;
          var elapsedTimeInMillis =
              DateTime.now().millisecondsSinceEpoch - checkoutTimeInMillis;
          if (elapsedTimeInMillis >= fifteenMinutesInMillis) {
            transaction.update(cartDoc.reference, {
              'isBooked': false,
              'checkoutTime': '',
              'stallName': stallName,
              'totalAmount': ''
            });
          }
        }
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase Successful'),
      ),
    );

    setState(() {
      _isCheckingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isCheckingOut,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 233, 226),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 242, 233, 226),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'My Cart',
                    style: GoogleFonts.raleway(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.userId)
                        .collection('carts')
                        .where('bookNow', isEqualTo: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'Cart is Empty',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var cartDoc = snapshot.data!.docs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              elevation: 5,
                              color: Color.fromARGB(255, 242, 233, 226),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: cartDoc.id ==
                                                    'MERCHaXxrhJ2LZugT6AU'
                                                ? 'Merchandise'
                                                : 'Stall Name: ',
                                            style: TextStyle(
                                              fontWeight: cartDoc.id ==
                                                      'MERCHaXxrhJ2LZugT6AU'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: cartDoc.id ==
                                                    'MERCHaXxrhJ2LZugT6AU'
                                                ? ''
                                                : cartDoc['stallName'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.userId)
                                          .collection('carts')
                                          .doc(cartDoc.id)
                                          .collection('products')
                                          .get(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              productSnapshot) {
                                        if (!productSnapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        var products =
                                            productSnapshot.data!.docs;
                                        widget.productsList = products;
                                        var totalAmount = 0.0;
                                        var productWidgets = <Widget>[];

                                        for (var product in products) {
                                          var productId = product.id;
                                          var productName = product['name'];
                                          var price = product['price'];
                                          var imageUrl = product['imageUrl'];
                                          var quantity =
                                              quantities[productId] ??
                                                  product['quantity'];
                                          var stock = product['stock'];
                                          totalAmount += price * quantity;
                                          if (quantities[productId] == null) {
                                            quantities[productId] = quantity;
                                          }

                                          productWidgets.add(
                                            Row(
                                              children: [
                                                // Image
                                                Container(
                                                  width: 105,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        imageUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Product Name:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          Text(
                                                            productName,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Price: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '$price',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Quantity",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .remove_circle),
                                                            onPressed: () {
                                                              setState(() {
                                                                quantities[
                                                                        productId] =
                                                                    quantity;
                                                                if (quantities[
                                                                            productId] !=
                                                                        null &&
                                                                    quantities[
                                                                            productId]! >
                                                                        1) {
                                                                  quantities[
                                                                          productId] =
                                                                      quantities[
                                                                              productId]! -
                                                                          1;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                              quantity
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .add_circle),
                                                            onPressed: () {
                                                              setState(() {
                                                                quantities[
                                                                        productId] =
                                                                    quantity;
                                                                if (quantities[
                                                                        productId]! <
                                                                    stock) {
                                                                  quantities[
                                                                          productId] =
                                                                      (quantities[productId] ??
                                                                              0) +
                                                                          1;
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text(
                                                                          'Quantity cannot be more than Stock'),
                                                                    ),
                                                                  );
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Remove Product"),
                                                                    content: Text(
                                                                        "Do you want to remove this product?"),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(false);
                                                                        },
                                                                        child: Text(
                                                                            "No"),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(true);
                                                                        },
                                                                        child: Text(
                                                                            "Yes"),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ).then(
                                                                  (value) async {
                                                                if (value !=
                                                                        null &&
                                                                    value) {
                                                                  // Remove the product
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(widget
                                                                          .userId)
                                                                      .collection(
                                                                          'carts')
                                                                      .doc(cartDoc
                                                                          .id)
                                                                      .collection(
                                                                          'products')
                                                                      .doc(
                                                                          productId)
                                                                      .delete();

                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(widget
                                                                          .userId)
                                                                      .collection(
                                                                          'carts')
                                                                      .doc(cartDoc
                                                                          .id)
                                                                      .collection(
                                                                          'products')
                                                                      .get()
                                                                      .then(
                                                                          (querySnapshot) {
                                                                    if (querySnapshot
                                                                        .docs
                                                                        .isEmpty) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(widget
                                                                              .userId)
                                                                          .collection(
                                                                              'carts')
                                                                          .doc(cartDoc
                                                                              .id)
                                                                          .delete();
                                                                    }
                                                                  });

                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          'Product Removed from Cart'),
                                                                    ),
                                                                  );
                                                                  setState(
                                                                      () {});
                                                                }
                                                              });
                                                            },
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .trash,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .add_circle),
                                                            onPressed: () {
                                                              print(
                                                                  "BUTTON PRESSED!!!!");
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PhonePePayment(
                                                                          widget
                                                                              .userId),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          productWidgets
                                              .add(SizedBox(height: 15));
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...productWidgets,
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text:
                                                        'Total Payable Amount: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '$totalAmount',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(width: 5),
                                                cartDoc['isBooked'] == true
                                                    ? Text(
                                                        'Booked',
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                        ),
                                                      )
                                                    : ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  128,
                                                                  69,
                                                                  60),
                                                        ),
                                                        onPressed: () {
                                                          if (_isCheckingOut ==
                                                              null) {
                                                            return null;
                                                          } else if (cartDoc
                                                                  .id ==
                                                              'MERCHaXxrhJ2LZugT6AU') {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Merchandise booking is under development'),
                                                              ),
                                                            );
                                                          } else {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Checkout'),
                                                                  content: Text(
                                                                      'Are you sure you want to checkout?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(false); // Close the dialog and return false
                                                                      },
                                                                      child: Text(
                                                                          'No'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(true); // Close the dialog and return true
                                                                      },
                                                                      child: Text(
                                                                          'Yes'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ).then((confirmed) {
                                                              if (confirmed !=
                                                                      null &&
                                                                  confirmed) {
                                                                checkout(
                                                                  cartDoc[
                                                                      'stallName'],
                                                                  totalAmount,
                                                                  products,
                                                                  cartDoc,
                                                                );
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                          'Checkout',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 128, 69, 60),
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Remove from Cart'),
                                                          content: Text(
                                                              'Are you sure you want to remove this item from your cart?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        false); // Close the dialog and return false
                                                              },
                                                              child: Text('No'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        true); // Close the dialog and return true
                                                              },
                                                              child:
                                                                  Text('Yes'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ).then((confirmed) {
                                                      if (confirmed != null &&
                                                          confirmed) {
                                                        // User confirmed removal, proceed with deletion logic
                                                        WriteBatch batch =
                                                            FirebaseFirestore
                                                                .instance
                                                                .batch();
                                                        for (var product
                                                            in widget
                                                                .productsList!) {
                                                          var productId =
                                                              product.id;
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(
                                                                  widget.userId)
                                                              .collection(
                                                                  'carts')
                                                              .doc(cartDoc.id)
                                                              .collection(
                                                                  'products')
                                                              .doc(productId)
                                                              .delete();
                                                        }

                                                        var productsCollectionRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(widget
                                                                    .userId)
                                                                .collection(
                                                                    'carts')
                                                                .doc(cartDoc.id)
                                                                .collection(
                                                                    'products');

                                                        batch
                                                            .commit()
                                                            .then((_) {
                                                          productsCollectionRef
                                                              .parent!
                                                              .delete();
                                                        });

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(widget.userId)
                                                            .collection('carts')
                                                            .doc(cartDoc.id)
                                                            .delete();

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Stall removed from Cart'),
                                                          ),
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    'Remove from Cart',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isCheckingOut)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

// class ThankYou extends StatelessWidget {
//   final String stallName;
//   final String sellerName;
//   const ThankYou(this.stallName, this.sellerName);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Thank You for Shopping with",
//             style: GoogleFonts.raleway(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 126, 70, 62),
//             ),
//           ),
//           Text(
//             stallName,
//             style: GoogleFonts.raleway(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 126, 70, 62),
//             ),
//           ),
//           Text(
//             "The Owner of the Stall",
//             style: GoogleFonts.raleway(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 126, 70, 62),
//             ),
//           ),
//           Text(
//             "$sellerName will be very pleased",
//             style: GoogleFonts.raleway(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 126, 70, 62),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }
