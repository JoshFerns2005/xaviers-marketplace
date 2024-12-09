// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/sellerscreens/seller_signin_screen.dart';
import '/consts/rounded_textfield.dart';
import '/services/auth_services.dart';

final _formKey1 = GlobalKey<FormState>();

class CreateAccountSellerScreen extends StatefulWidget {
  const CreateAccountSellerScreen({super.key});

  @override
  State<CreateAccountSellerScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountSellerScreen> {
  // Text controllers
  final nameController = TextEditingController();
  final mobController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRetypeController = TextEditingController();

  String? validateName(String? name) {
    RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
    final isNameValid = nameRegex.hasMatch(name ?? '');
    final containsNumber =
        RegExp(r'\d').hasMatch(name ?? ''); // Check if name contains a number
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (!isNameValid || containsNumber) {
      return "Please enter a valid name without including any numbers";
    }
    return null;
  }

  String? validateMob(String? mob) {
    RegExp mobRegex = RegExp(
        r'^\+?[1-9]\d{9}$'); // Adjusted the regex pattern to ensure exactly 10 digits
    final isMobValid = mobRegex.hasMatch(mob ?? '');
    if (mob == null || mob.trim().isEmpty) {
      return 'Mobile Number is required';
    }
    if (mob.length != 10 || !isMobValid) {
      // Added a length check to ensure exactly 10 digits
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(?:\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? password) {
    RegExp uppercaseRegex = RegExp(r'[A-Z]');
    RegExp lowercaseRegex = RegExp(r'[a-z]');
    RegExp digitRegex = RegExp(r'\d');
    RegExp specialCharRegex = RegExp(r'[@$!%*?&]');

    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8 || password.length > 20) {
      return 'Password must be between 8 and 20 characters long';
    }

    if (!uppercaseRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!lowercaseRegex.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!digitRegex.hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!specialCharRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  void handleSellerSignUp() async {
    try {
      User? signedUpUser = await signUpAsSeller(
        emailController.text,
        passwordController.text,
        nameController.text,
        mobController.text,
      );

      if (signedUpUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SellerSignInScreen(),
          ),
        );
        print('Seller signed up successfully');
      } else {
        print('Error during seller sign-up');
      }
    } catch (error) {
      print('Error during seller sign-up: $error');
    }
  }

  bool _isSecurePassword = true;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: const BackButton(color: Colors.brown),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 242, 233, 226).withOpacity(0.85),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 150, 16, 0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Create Seller Account',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RoundedTextField(
                      label: 'Name',
                      textColor: Colors.brown,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: validateName,
                    ),
                    const SizedBox(height: 12),
                    RoundedTextField(
                      label: 'Mobile Number',
                      textColor: Colors.brown,
                      controller: mobController,
                      keyboardType: TextInputType.phone,
                      validator: validateMob,
                    ),
                    const SizedBox(height: 12),
                    RoundedTextField(
                      label: 'Email',
                      textColor: Colors.brown,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 12),
                    RoundedTextField(
                      label: 'Password',
                      textColor: Colors.brown,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      validator: validatePassword,
                      isObscure: _isSecurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isSecurePassword = !_isSecurePassword;
                            if (!_isSecurePassword) {
                              _timer = Timer(
                                const Duration(seconds: 1),
                                () {
                                  setState(() {
                                    _isSecurePassword = true;
                                    _timer = null; // Reset the timer
                                  });
                                },
                              );
                            } else {
                              _timer
                                  ?.cancel(); // Cancel the timer if password visibility is toggled back
                            }
                          });
                        },
                        icon: _isSecurePassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RoundedTextField(
                      label: 'Confirm Password',
                      textColor: Colors.brown,
                      controller: passwordRetypeController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      isObscure: _isSecurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isSecurePassword = !_isSecurePassword;
                            if (!_isSecurePassword) {
                              _timer = Timer(
                                const Duration(seconds: 1),
                                () {
                                  setState(() {
                                    _isSecurePassword = true;
                                    _timer = null; // Reset the timer
                                  });
                                },
                              );
                            } else {
                              _timer
                                  ?.cancel(); // Cancel the timer if password visibility is toggled back
                            }
                          });
                        },
                        icon: _isSecurePassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey1.currentState!.validate()) {
                          handleSellerSignUp();
                        } else {
                          print(
                              'Form validation failed'); // Add a print statement for debugging
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.brown,
                      ),
                      child: const Text('Confirm'),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                              color: Colors.brown,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign in.",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (context != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SellerSignInScreen(),
                                        ),
                                      );
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedTextField extends StatefulWidget {
  final String label;
  final Color textColor;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool isObscure;
  final Widget? suffixIcon;

  const RoundedTextField({
    super.key,
    required this.label,
    required this.textColor,
    required this.controller,
    required this.keyboardType,
    this.validator,
    this.isObscure = false,
    this.suffixIcon,
  });

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isObscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: (value) {
        setState(() {
          isValid = widget.validator?.call(value) == null;
        });
      },
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.textColor),
        suffixIcon: isValid
            ? const Icon(Icons.check, color: Colors.green)
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
