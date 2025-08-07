import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/secure_storage.dart';

import '../design/personal_area_design.dart';
import '../services/auth_service.dart';

class PersonalAreaScreen extends StatefulWidget {
  const PersonalAreaScreen({super.key});

  @override
  State<PersonalAreaScreen> createState() => _PersonalAreaScreeState();
}

class _PersonalAreaScreeState extends State<PersonalAreaScreen> {
   String? _username;
   String? _email;

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
             onPressed: () async {
               Navigator.pop(context); // Close dialog
               await SecureStorage.deleteToken(); // Delete token

               if (!mounted) return;

               //Show SnackBar
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('You have been logged out.'),
                   duration: Duration(seconds: 2),
                   behavior: SnackBarBehavior.floating,
                 ),
               );

               //Wait to show SnackBar before navigation
               await Future.delayed(Duration(milliseconds: 800));

               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => const LoginScreen()),
               );
             },
             child: Text('Logout', style: TextStyle(color: Colors.red)),
           ),
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
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await AuthService.loadUserInfo();
    if (userInfo != null && mounted) {
      setState(() {
        _username = userInfo['username'];
        _email = userInfo['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Account')),
      body: _username == null || _email == null
          ? Center(child: CircularProgressIndicator())
          : PersonalAreaDesign(
        username: _username!,
        email: _email!,
        onLogout: () => _handleLogout(context),
        onEditProfile: () => _handleEditProfile(context),
        onChangePassword: () => _handleChangePassword(context),
      ),
    );
  }
}