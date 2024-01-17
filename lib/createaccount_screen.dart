import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xaviers_market/consts/firebase_consts.dart';
import 'package:flutter/material.dart';
import 'rounded_textfield.dart';
import 'signin_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  
  //text controllers
  var nameController = TextEditingController();
  var mobController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/start_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 26, 3, 59).withOpacity(0.85),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  RoundedTextField(
                    label: 'Name',
                    textColor: Colors.white,
                    controller: nameController,
                    isObscure: false
                  ),
                  SizedBox(height: 12),
                  RoundedTextField(
                    label: 'Mobile Number',
                    textColor: Colors.white,
                    controller: mobController,
                    isObscure: false
                  ),
                  SizedBox(height: 12),
                  RoundedTextField(
                    label: 'Email',
                    textColor: Colors.white,
                    controller: emailController,
                    isObscure: false
                  ),
                  SizedBox(height: 12),
                  RoundedTextField(
                    label: 'Password',
                    textColor: Colors.white,
                    controller: passwordController,
                    isObscure: true
                  ),
                  SizedBox(height: 12),
                  RoundedTextField(
                    label: 'Confirm Password',
                    textColor: Colors.white,
                    controller: passwordRetypeController,
                    isObscure: true
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {

                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) async {
                          
                          DocumentReference store = await firestore.collection(usersCollection).doc(currentUser!.uid);
                          store.set({'name': nameController.text, 'mob': mobController.text , 'email': emailController.text, 'password': passwordController.text, 'imageUrl': ''});
                          
                          print("Created New Account");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                              ),
                          );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: Text('Confirm'),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Already have an account? Sign in.",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}