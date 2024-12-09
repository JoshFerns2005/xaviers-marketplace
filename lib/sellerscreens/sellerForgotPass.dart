import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xaviers_market/features/changePass.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          ForgotPasswordForm(), // You can define the initial route here if needed
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handlePasswordReset() async {
    String email = _emailController.text;
    String mobile = _mobileController.text;
    setState(() {
      _isLoading = true;
    });
    // Query the database to check if email and mobile match
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('mob', isEqualTo: mobile)
        .get();

    // If there is a match
    if (querySnapshot.docs.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPasswordPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No match found. Please check your email and mobile.'),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: const Color.fromARGB(255, 126, 70, 62),
          ),
        ),
        leading: BackButton(
          color: const Color.fromARGB(255, 126, 70, 62),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handlePasswordReset,
                      child: Text('Reset Password'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.brown),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
