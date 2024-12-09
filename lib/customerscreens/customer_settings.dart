import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:xaviers_market/consts/consts.dart';
import 'package:xaviers_market/customer_or_seller.dart';
import 'package:xaviers_market/customerscreens/Profile.dart';
import 'package:xaviers_market/features/AboutUs.dart';
import 'package:xaviers_market/features/changePass.dart';

class CustomerSettingsScreen extends StatefulWidget {
  const CustomerSettingsScreen({Key? key}) : super(key: key);

  @override
  _CustomerSettingsScreenState createState() => _CustomerSettingsScreenState();
}

class _CustomerSettingsScreenState extends State<CustomerSettingsScreen> {
  bool _notificationsEnabled = true; // Set initial value as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        leading: const BackButton(
          color: Color.fromARGB(255, 126, 70, 62),
        ),
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color.fromARGB(255, 126, 70, 62),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 126, 70, 62),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                  ),
                );
              },
            ),
            
            Divider(),
            const SizedBox(height: 20),
            const Text(
              'Other Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 126, 70, 62),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () async {
                try {
                  // Remove stored credentials
                  var box = await Hive.openBox('userBox');
                  box.delete('userId');
                  box.delete('isSignedIn');
                  box.delete('isSeller');
                  await FirebaseAuth.instance.signOut();
                  print('Signed out');
                  // Navigate to your sign-in or home screen after signing out
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SellOrCustomerScreen()), // Replace SignInScreen with your sign-in screen
                  );
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
