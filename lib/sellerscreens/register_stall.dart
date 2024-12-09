// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaviers_market/consts/rounded_textfield.dart';
import 'package:xaviers_market/sellerscreens/seller_product_screen.dart';
import 'package:xaviers_market/sellerscreens/seller_stalls_screen.dart';

class RegisterStall extends StatefulWidget {
  final String userId;
  const RegisterStall(this.userId, {super.key});

  @override
  State<RegisterStall> createState() => _RegisterStallState();
}

class _RegisterStallState extends State<RegisterStall> {
  var nameController = TextEditingController();
  File? _image;
  bool _uploading = false; // Flag to track whether the image is uploading
  String imageUrl = "";
  String stallName = "";
  final picker = ImagePicker();

  Future<void> addStall() async {
  try {
    // Get the current timestamp
    DateTime createdAt = DateTime.now();

    // Add the stall with the createdAt timestamp
    DocumentReference stallRef = await FirebaseFirestore.instance
        .collection('stalls')
        .add({
      'name': stallName,
      'imageUrl': imageUrl,
      'userId': widget.userId,
      'createdAt': createdAt,
    });

    // Navigate to the seller products screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SellerProductsScreen(widget.userId, stallRef.id),
      ),
    );

    print('Stall added successfully');
  } catch (error) {
    print('Error adding stall: $error');
  }
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
                    builder: (context) => StallsScreen(widget.userId)));
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Register Your Stall',
                      style: TextStyle(
                        color: Color.fromARGB(255, 126, 70, 62),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                 RoundedTextField(
                    label: 'Name of Your Stall',
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
                  _image != null
                      ? Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  Center(
                    child: SizedBox(
                      width: 150, // Adjust the width as needed
                      child: ElevatedButton(
                        onPressed: _uploading
                            ? null
                            : () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Choose an option"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.camera),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    "Camera",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                XFile? file =
                                                    await picker.pickImage(
                                                  source: ImageSource.camera,
                                                );
                                                if (file != null) {
                                                  setState(() {
                                                    _image = File(file.path);
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.photo_album),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    "Gallery",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                XFile? file =
                                                    await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                );
                                                if (file != null) {
                                                  setState(() {
                                                    _image = File(file.path);
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 126, 70, 62),
                        ),
                        child: const Text(
                          'Select Image',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: SizedBox(
                      width: 150, // Adjust the width as needed
                      child: ElevatedButton(
                        onPressed: _uploading
                            ? null
                            : () async {
                                if (_image != null) {
                                  setState(() {
                                    _uploading = true;
                                  });

                                  String uniqueFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceDirImages =
                                      referenceRoot.child('stall_images');
                                  Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);
                                  try {
                                    await referenceImageToUpload
                                        .putFile(_image!);

                                    // Upload is complete when reaching this point
                                    imageUrl = await referenceImageToUpload
                                        .getDownloadURL();
                                    stallName = nameController.text;
                                    await addStall();
                                  } catch (error) {
                                    print("Error performing upload: $error");
                                  } finally {
                                    setState(() {
                                      _uploading = false;
                                    });
                                  }
                                } else {
                                  print(
                                      'Please select an image for your stall.');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 126, 70, 62),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_uploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
