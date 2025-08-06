import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';

import '../design/personal_area_design.dart';

class PersonalAreaScreen extends StatefulWidget {
  const PersonalAreaScreen({super.key});

  @override
  State<PersonalAreaScreen> createState() => _PersonalAreaScreeState();

}

class _PersonalAreaScreeState extends State<PersonalAreaScreen> {

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); //Close Dialog
              //TODO: clear session
              Navigator.pushReplacement(context, LoginScreen);
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  void _handleEditProfile(BuildContext context) {
    // TODO: Navigate to edit profile screen
  }

  void _handleChangePassword(BuildContext context) {
    // TODO: Navigate to change password screen
  }

  @override
  Widget build(BuildContext context) {
    // Mocked data — replace with real state
    final userName = 'John Doe';
    final userEmail = 'john.doe@example.com';

    return Scaffold(
      appBar: AppBar(title: Text('My Account')),
      body: PersonalAreaDesign(
        username: userName,
        email: userEmail,
        onLogout: () => _handleLogout(context),
        onEditProfile: () => _handleEditProfile(context),
        onChangePassword: () => _handleChangePassword(context),
      ),
    );
  }
}

}