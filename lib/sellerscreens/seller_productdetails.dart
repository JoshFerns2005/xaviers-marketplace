import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:xaviers_market/customerscreens/cart.dart';
import 'package:xaviers_market/sellerscreens/edit_product_details.dart';
import 'package:xaviers_market/sellerscreens/seller_product_screen.dart';

class SellerProductDetailsScreen extends StatefulWidget {
  final String userId;
  final String stallId;
  final String productId;

  SellerProductDetailsScreen(this.userId, this.stallId, this.productId);

  @override
  _SellerProductDetailsScreenState createState() =>
      _SellerProductDetailsScreenState();
}

class _SellerProductDetailsScreenState
    extends State<SellerProductDetailsScreen> {
  late PageController _pageController;
  double _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 233, 226),
            appBar: AppBar(
              leading: BackButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellerProductsScreen(
                            widget.userId, widget.stallId)));
              }),
              title: Text('Product Details'),
            ),
            body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('stalls')
                  .doc(widget.stallId)
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
          

                // Assuming 'images' is a subcollection
                var imagesCollection = FirebaseFirestore.instance
                    .collection('stalls')
                    .doc(widget.stallId)
                    .collection('products')
                    .doc(widget.productId)
                    .collection('images')
                    .snapshots();

                return StreamBuilder<QuerySnapshot>(
                  stream: imagesCollection,
                  builder: (context, imagesSnapshot) {
                    if (imagesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    var imageDocs = imagesSnapshot.data?.docs;

                    if (imageDocs == null || imageDocs.isEmpty) {
                      return Text('No images available');
                    }

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('stalls')
                          .doc(widget.stallId)
                          .get(),
                      builder: (context, stallSnapshot) {
                        if (stallSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (!stallSnapshot.hasData) {
                          return Text('No stall data available');
                        }

                        var stallData =
                            stallSnapshot.data!.data() as Map<String, dynamic>;
                        var stallName = stallData['name'] ??
                            'No Stall Name'; // Default if name is not available

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
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 15),
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
                              padding:
                                  const EdgeInsets.only(top: 3.0, left: 15),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Stall Name: ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 126, 70,
                                            62), // Set the fontWeight to normal for 'Stall Name'
                                      ),
                                    ),
                                    TextSpan(
                                      text: stallName,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 3.0, left: 15,  ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                 top: 3, left: 15, bottom: 20),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Stock: ',
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
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProduct(
                                                        widget.userId,
                                                        widget.stallId,
                                                        widget.productId)));
                                      },
                                      child: Text("Edit Product Details",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 126, 70, 62),
                                        fixedSize: Size.fromWidth(
                                            MediaQuery.of(context).size.width /
                                                1.05),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Remove Product'),
                                              content: Text(
                                                  'Are you sure you want to remove this product?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(
                                                        false); // Close the dialog and return false
                                                  },
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });

                                                    // Delete the product from Firestore
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('stalls')
                                                        .doc(widget.stallId)
                                                        .collection('products')
                                                        .doc(widget.productId)
                                                        .delete();

                                                    // Navigate back to the seller products screen
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SellerProductsScreen(
                                                                widget.userId,
                                                                widget.stallId),
                                                      ),
                                                    );

                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Remove this Product",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 126, 70, 62),
                                        fixedSize: Size.fromWidth(
                                            MediaQuery.of(context).size.width /
                                                1.05),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (_isLoading)
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
