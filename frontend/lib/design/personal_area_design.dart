import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalAreaDesign extends StatelessWidget {
  final String username;
  final String email;
  final VoidCallback onLogout;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  const PersonalAreaDesign({
    Key? key,
    required this.username,
    required this.email,
    required this.onLogout,
    required this.onEditProfile,
    required this.onChangePassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //User information
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: TextStyle(fontSize: 18)),
                  Text(email, style: TextStyle(color: Colors.grey[600])),
                ],
              )
            ],
          ),
        ),
        Divider(),

        //Action list
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile'),
                onTap: onEditProfile,
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Change Password'),
                onTap: onChangePassword,
              ),
            ],
          ),
        ),
        //Logout button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: onLogout,
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }
}
