// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPage extends StatelessWidget {
  final String userId;
  const OrderPage(this.userId);

  @override
  Widget build(BuildContext context) {
    // Assuming you have a cartItems list and calculateTotal method
    List<List<String>> cartItems = []; // Replace with your list
    double calculateTotal() {
      double total = 0;
      for (var item in cartItems) {
        total += double.parse(item[1]);
      }
      return total;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Let's order fresh items for you
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "My Orders",
              style: GoogleFonts.notoSerif(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // list view of cart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          cartItems[index][2],
                          height: 36,
                        ),
                        title: Text(
                          cartItems[index][0],
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          '\$' + cartItems[index][1],
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            // Remove item from cart
                            // cartItems.removeAt(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // total amount + pay now

          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(color: Colors.yellow),
                      ),

                      const SizedBox(height: 8),
                      // total price
                      Text(
                        '\₹${calculateTotal()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // pay now
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade200),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: const [
                        Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
