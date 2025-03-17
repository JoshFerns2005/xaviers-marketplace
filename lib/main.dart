import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:xaviers_market/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "Insert your api key",
      appId: "1:375849621262:android:39d50c74a80c340d0de95f",
      messagingSenderId: "375849621262",
      projectId: "xavier-s-market-2621f",
      storageBucket: "xavier-s-market-2621f.appspot.com"
    ),
  )
  :await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('AIzaSyA0SJmAEp7gbj8YJzq_HIQ7nDeDlIE0rYE'),
    androidProvider: AndroidProvider.debug,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
   return const MaterialApp(
    home: SplashScreen(),
   );
  }
}
