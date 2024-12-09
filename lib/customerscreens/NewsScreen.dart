// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String content;

  const NewsDetailsScreen({super.key, 
    required this.title,
    required this.imagePath,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 126, 70, 62),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 126, 70, 62),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(imagePath),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 126, 70, 62),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
