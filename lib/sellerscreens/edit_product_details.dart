// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:xaviers_market/consts/consts.dart';
import 'package:xaviers_market/sellerscreens/register_stall.dart';
import 'package:xaviers_market/consts/rounded_textfield.dart';
import 'package:xaviers_market/sellerscreens/seller_product_screen.dart';
import 'package:xaviers_market/sellerscreens/seller_productdetails.dart';


class EditProduct extends StatefulWidget {
  final String userId;
  final String stallId;
  final String productId;

  const EditProduct(this.userId, this.stallId, this.productId, {super.key});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var nameController = TextEditingController();
  var priceController = TextEditingController();

  Future<void> editProduct() async {
    try {
      // Update product details to Firestore
      DocumentReference stallRef =
          FirebaseFirestore.instance.collection('stalls').doc(widget.stallId);
      CollectionReference productsCollection = stallRef.collection('products');

      Map<String, dynamic> finalDetails = {
      'name': nameController.text,
      'stallId': widget.stallId,
      'price': double.tryParse(priceController.text),
    };

      productsCollection
      .doc(widget.productId)
      .set(finalDetails)
      .then((value) => print("Details Updated"))
      .catchError((error) => print("Failed to update details: $error"));

      print('Product updated successfully');
    } catch (error) {
      print('Error updating product: $error');
    }

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => SellerProductDetailsScreen(widget.userId, widget.stallId, widget.productId))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        leading: BackButton(
          color: const Color.fromARGB(255, 126, 70, 62),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SellerProductsScreen(widget.userId, widget.stallId)));
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Edit Product',
                    style: TextStyle(
                      color: Color.fromARGB(255, 126, 70, 62),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RoundedTextField(
                    label: 'Name of the Product',
                    textColor: Colors.black87,
                    controller: nameController,
                    isObscure: false, 
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return null;
                      },
                  ),
                  const SizedBox(height: 16),
                  RoundedTextField(
                    label: 'Price',
                    textColor: Colors.black87,
                    controller: priceController,
                    isObscure: false,
                    obscureText: false,
                    keyboardType: TextInputType.number, validator: (value) {
                      return null;
                      },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      editProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.lightBlueAccent,
                    ),
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}