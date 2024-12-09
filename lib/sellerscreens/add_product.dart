// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:xaviers_market/sellerscreens/register_stall.dart';
import 'package:xaviers_market/consts/rounded_textfield.dart';
import 'package:xaviers_market/sellerscreens/seller_product_screen.dart';

class AddProduct extends StatefulWidget {
  final String userId;
  final String stallId;

  const AddProduct(this.userId, this.stallId, {super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var stockController = TextEditingController();

  final List<File?> _images = List.generate(10, (index) => null);
  int _uploadedImageCount = 0;
  final List<String> _uploadStatus = [];
  bool _isUploading = false;

  Future<void> addProduct(String productName) async {
    try {
      // Set uploading flag to true
      setState(() {
        _isUploading = true;
      });

      // Add product details to Firestore
      DocumentReference stallRef =
          FirebaseFirestore.instance.collection('stalls').doc(widget.stallId);
      CollectionReference productsCollection = stallRef.collection('products');

      DocumentReference productRef = await productsCollection.add({
        'name': nameController.text,
        'stallId': widget.stallId,
        'price': double.tryParse(priceController.text),
        'stock': double.tryParse(stockController.text),

        // Add other product-related fields as needed
      });

      // Upload images to Firebase Storage and get download URLs
      for (int i = 0; i < _uploadedImageCount; i++) {
        File? image = _images[i];
        if (image != null) {
          String uniqueFileName =
              DateTime.now().millisecondsSinceEpoch.toString();
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('product_images');
          Reference referenceImageToUpload =
              referenceDirImages.child('$uniqueFileName-$i');

          try {
            await referenceImageToUpload.putFile(image);
            String imageUrl = await referenceImageToUpload.getDownloadURL();

            // Add image URL to the product document
            await productRef.collection('images').add({
              'url': imageUrl,
            });
          } catch (error) {
            print("Error performing upload: $error");
          }
        }
      }

      // Set uploading flag to false
      setState(() {
        _isUploading = false;
      });

      // Navigate to SellerProductsScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SellerProductsScreen(widget.userId, widget.stallId),
        ),
      );

      print('Product added successfully');
    } catch (error) {
      // Set uploading flag to false in case of error
      setState(() {
        _isUploading = false;
      });

      print('Error adding product: $error');
    }
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
        _uploadedImageCount = _images.where((image) => image != null).length;
      });
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
                    'Add Product',
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
                    isObscure: false, obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  RoundedTextField(
                    label: 'Price',
                    textColor: Colors.black87,
                    controller: priceController,
                    isObscure: false,
                     obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  RoundedTextField(
                    label: 'In Stock',
                    textColor: Colors.black87,
                    controller: stockController,
                    isObscure: false,
                    obscureText: false,
                    validator: (value) {
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: _isUploading
                    ? null
                    : () async {
                        await _showImagePickerModalBottomSheet(context);
                      },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 250, 168, 16),
                    ),
                    child: const Text('Upload Images'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () async {
                            addProduct(nameController.text);
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.lightBlueAccent,
                    ),
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(height: 16),
                  if (_isUploading)
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePickerModalBottomSheet(BuildContext context) async {
  final selectedImages = await showModalBottomSheet<List<File>>(
    context: context,
    builder: (BuildContext context) {
      return _ImagePickerModalBottomSheet(images: _images, pickImage: _pickImage);
    },
  );

  if (selectedImages != null) {
    setState(() {
      _images.clear();
      _images.addAll(selectedImages);
      _uploadedImageCount = _images.where((image) => image != null).length;
    });
  }
}

}

class _ImagePickerDialog extends StatefulWidget {
  final List<File?> images;
  final int uploadedImageCount;
  final List<String> uploadStatus;
  final Function(int) pickImage;

  const _ImagePickerDialog({
    required this.images,
    required this.uploadedImageCount,
    required this.uploadStatus,
    required this.pickImage,
  });

  @override
  _ImagePickerDialogState createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<_ImagePickerDialog> {
  bool isImagePicked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Images'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: widget.uploadedImageCount < 10
                ? () async {
                    widget.pickImage(widget.uploadedImageCount);
                    setState(() {
                      final formattedCount =
                          NumberFormat().format(widget.uploadedImageCount);
                      widget.uploadStatus
                          .add('$formattedCount image uploaded');
                      isImagePicked =
                          true; // Set flag to true after picking an image
                    });
                  }
                : null,
          ),
          if (isImagePicked &&
              widget.uploadStatus
                  .isNotEmpty) // Show text only if an image is picked
            const SizedBox(height: 16),
          for (String status in widget.uploadStatus) Text(status),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}











class _ImagePickerModalBottomSheet extends StatefulWidget {
  final List<File?> images;
  final Function(int) pickImage;

  const _ImagePickerModalBottomSheet({
    required this.images,
    required this.pickImage,
  });

  @override
  _ImagePickerModalBottomSheetState createState() => _ImagePickerModalBottomSheetState();
}

class _ImagePickerModalBottomSheetState extends State<_ImagePickerModalBottomSheet> {
  List<File> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Images (up to 5)'),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: selectedImages.length < 5
  ? () {
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
                        SizedBox(width: 8,),
                        Text("Camera", style: TextStyle(fontSize: 17),),
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      // Add your camera logic here
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.camera);

                        if (pickedFile != null) {
                            setState(() {
                            selectedImages.add(File(pickedFile.path));
                          });
                        }
                    },
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        SizedBox(width: 8,),
                        Text("Gallery", style: TextStyle(fontSize: 17),),
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                            setState(() {
                            selectedImages.add(File(pickedFile.path));
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
    }
  : null,
              ),
              Text('${selectedImages.length} selected'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: selectedImages.length,
              itemBuilder: (BuildContext context, int index) {
                final image = selectedImages[index];
                return ListTile(
                  leading: Image.file(image),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        selectedImages.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedImages);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
