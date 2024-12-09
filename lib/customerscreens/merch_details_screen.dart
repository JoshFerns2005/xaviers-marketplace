import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:xaviers_market/customerscreens/cart.dart';

class MerchDetailsScreen extends StatefulWidget {
  final String userId;
  final String merchId;
  final String productId;

  MerchDetailsScreen(this.userId, this.merchId, this.productId);

  @override
  _MerchDetailsScreenState createState() => _MerchDetailsScreenState();
}

class _MerchDetailsScreenState extends State<MerchDetailsScreen> {
  late PageController _pageController;
  double _currentPage = 0;
  GlobalKey<_QuantitySelectorState> quantitySelectorKey =
      GlobalKey<_QuantitySelectorState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('merchandise')
            .doc(widget.merchId)
            .collection('products')
            .doc(widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Text('No data available');
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>;
          var productName = productData['name'] ??
              'No Product Name'; // Default if name is not available
          var price = productData['price'] ?? 'Price not Defined';
          var stock = productData['stock'];
          QuantitySelector quantitySelector =
              QuantitySelector(stock, key: quantitySelectorKey);

          // Assuming 'images' is a subcollection
          var imagesCollection = FirebaseFirestore.instance
              .collection('merchandise')
              .doc(widget.merchId)
              .collection('products')
              .doc(widget.productId)
              .collection('images')
              .snapshots();

          return StreamBuilder<QuerySnapshot>(
            stream: imagesCollection,
            builder: (context, imagesSnapshot) {
              if (imagesSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              var imageDocs = imagesSnapshot.data?.docs;

              if (imageDocs == null || imageDocs.isEmpty) {
                return Text('No images available');
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('merchandise')
                    .doc(widget.merchId)
                    .get(),
                builder: (context, merchSnapshot) {
                  if (merchSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!merchSnapshot.hasData) {
                    return Text('No stall data available');
                  }

                  var merchData =
                      merchSnapshot.data!.data() as Map<String, dynamic>;
                  var merchCategoryName = merchData['name'] ??
                      'No Category Name'; // Default if name is not available

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageDocs.length,
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            var imageUrl = imageDocs[index]['url'];
                            return Container(
                              height: double.infinity,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center the dots
                        children: [
                          DotsIndicator(
                            dotsCount: imageDocs.length,
                            position: _currentPage.toInt(),
                            decorator: DotsDecorator(
                              size: const Size.square(8.0),
                              activeSize: const Size(20.0, 8.0),
                              color: Colors.black26,
                              activeColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 15),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Item Name: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 126, 70,
                                      62), // Set the fontWeight to normal for 'Item Name'
                                ),
                              ),
                              TextSpan(
                                text: productName,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 126, 70,
                                      62), // Set the fontWeight to bold for the productName
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 15),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Category Name: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 126, 70,
                                      62), // Set the fontWeight to normal for 'Stall Name'
                                ),
                              ),
                              TextSpan(
                                text: merchCategoryName,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 126, 70,
                                      62), // Set the fontWeight to bold for the stallName
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 3.0, left: 15, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'In Stock: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 126, 70,
                                      62), // Set the fontWeight to normal for 'Stall Name'
                                ),
                              ),
                              TextSpan(
                                text: stock.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 126, 70,
                                      62), // Set the fontWeight to bold for the stallName
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Price: ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(255, 126, 70,
                                        62), // Set the fontWeight to normal for 'Stall Name'
                                  ),
                                ),
                                TextSpan(
                                  text: price.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 126, 70,
                                        62), // Set the fontWeight to bold for the stallName
                                  ),
                                ),
                              ],
                            ),
                          ),
                          quantitySelector,
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Merchandise booking is under development'),
                                  ),
                                );
                            },
                            child: Text("Buy Now",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 126, 70, 62),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width / 1.05),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              try {

                                int selectedQuantity = quantitySelectorKey
                                        .currentState
                                        ?.getQuantity() ?? 1;

                                // Check if the user's cart document exists
                                var cartDoc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.userId)
                                    .collection('carts')
                                    .doc('MERCHaXxrhJ2LZugT6AU')
                                    .get();

                                // If the cart document doesn't exist, create a new one
                                if (!cartDoc.exists) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.userId)
                                      .collection('carts')
                                      .doc('MERCHaXxrhJ2LZugT6AU')
                                      .set({
                                        'bookNow': false,
                                        'isBooked': false,
                                        'totalAmount': '',
                                      });
                                }

                                // Add the product details to the cart
                                // Fetching the URL of the first image
                                var imageUrl = imageDocs.isNotEmpty ? imageDocs.first['url'] : 'No image available';

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.userId)
                                    .collection('carts')
                                    .doc('MERCHaXxrhJ2LZugT6AU')
                                    .collection('products')
                                    .doc(widget.productId)
                                    .set({
                                  'name': productName,  
                                  'price': price,
                                  'imageUrl': imageUrl,
                                  'quantity': selectedQuantity,
                                  'stock': stock,
                                });

                                // Show a success message or navigate to the cart screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Product added to cart'),
                                  ),
                                );
                              } catch (error) {
                                // Handle errors
                                print('Error adding product to cart: $error');
                              }
                            },
                            child: Text("Add to Cart",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 126, 70, 62),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width / 1.05),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


class QuantitySelector extends StatefulWidget {
  final int stock;
  final Key key;

  QuantitySelector(this.stock, {required this.key});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  var quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Quantity",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 126, 70, 62),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.brown,
          ),
          onPressed: () {
            setState(() {
              if (quantity > 1) {
                quantity = quantity - 1;
              }
            });
          },
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 70, 62),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.brown),
          onPressed: () {
            setState(() {
              if (quantity == widget.stock) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cannot Book more than Units in Stock'),
                  ),
                );
              } else {
                quantity += 1;
              }
            });
          },
        ),
      ],
    );
  }

  int getQuantity() {
    return quantity;
  }
}
