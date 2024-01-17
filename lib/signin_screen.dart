import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/createaccount_screen.dart';
import 'rounded_textfield.dart';
import 'package:xaviers_market/home_screen.dart';

void main() {
  runApp(const SignInScreen());
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  RoundedTextField(
                    label: 'Email',
                    textColor: Colors.white,
                    controller: emailController,
                    isObscure: false
                  ),
                  SizedBox(height: 16),
                  RoundedTextField(
                    label: 'Password',
                    textColor: Colors.white,
                    controller: passwordController,
                    isObscure: true
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
                        print("Signed in Successfully");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => Home(),
                            ),
                          );
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()})");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: Text('Sign In'),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.fromLTRB(40,5,5,10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Don't have an account? Create one.",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

