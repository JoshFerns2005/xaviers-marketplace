import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrders extends StatelessWidget {
  final String userId;
  const MyOrders(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'My Orders',
              style: GoogleFonts.raleway(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('orders')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Orders Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                final orders = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderContainer(context, order);
                  },
                );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderContainer(BuildContext context, DocumentSnapshot order) {
    return Container(
      width: MediaQuery.of(context).size.width / 2, // Adjust width as needed
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
      child: Card(
        elevation: 5.0, // Add elevation for a shadow effect
        color: Color.fromARGB(255, 242, 233, 226),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stall Name",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        order['stallName'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Date and Time",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "${order['date']} - ${order['time']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25),
              FutureBuilder(
                future: order.reference.collection('products').get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  var products = snapshot.data!.docs;
                  if (products.isEmpty) {
                    return Text('No products');
                  }
                  List<String> productNames = products
                      .map((product) => product['productName'].toString())
                      .toList();
                  String productsText = productNames.join(", ");
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18), // Adjust the style as needed
                      children: [
                        TextSpan(text: 'Products: '),
                        TextSpan(
                            text: productsText,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Total Bill Amount: ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    order['totalAmount'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
