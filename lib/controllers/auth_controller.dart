import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/consts/consts.dart';

class AuthController extends GetxController {
  
  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //log in method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

  try {
    
    await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

  } on FirebaseAuthException catch (e) {
    VxToast.show(context, msg: e.toString());
  }
  return userCredential;
  }

  //signup method

  Future<UserCredential?> signupMethod({email,password,context}) async {
    UserCredential? userCredential;

  try {
    
    await auth.createUserWithEmailAndPassword(email: email, password: password);

  } on FirebaseAuthException catch (e) {
    VxToast.show(context, msg: e.toString());
  }
  return userCredential;
  }

  // storing data method
  storeUserData({name, mob, email, password}) async {

    DocumentReference store = await firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({'name': name, 'mob': mob , 'email': email, 'password': password, 'imageUrl': ''});
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }


}