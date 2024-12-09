import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 242, 233, 226),
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      title: Text(
        'Change Password',
        style: TextStyle(
          color: Color.fromARGB(255, 126, 70, 62),
        ),
      ),
    ),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _changePassword,
                child: Text('Confirm',style: TextStyle(
                  color: Color.fromARGB(255, 242, 233, 226),
                ),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 126, 70, 62),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}


  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });

      try {
        // Get the current user
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null && currentUser.email == _emailController.text) {
          // Sign in user with provided email and password
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          // If sign-in successful, navigate to change password page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPasswordPage()),
          );
        } else {
          // Show error message if email does not match current user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid email. Please check your email.'),
          ));
        }
      } catch (e) {
        // If sign-in fails, show error message
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to authenticate. Please check your email and password.'),
        ));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Color.fromARGB(255, 126, 70, 62),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }

                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updatePassword,
                      child: Text('Update Password',
                      style: TextStyle(
                      color: const Color.fromARGB(255, 242, 233, 226),
                      ),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 126, 70, 62),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });

      try {
        // Get the current user
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Update user password
          await currentUser.updatePassword(_passwordController.text);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password updated successfully'),
          ));

          // Navigate back to previous page
          Navigator.pop(context);
        } else {
          // Show error message if current user is null
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update password: Current user is null'),
          ));
        }
      } catch (e) {
        // Show error message if update fails
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update password. Please try again.'),
        ));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
