import 'package:flutter/material.dart';
import 'package:frontend/design/login_design.dart';
import '../services/auth_service.dart';
import 'field_management_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();

}
class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      bool success = await AuthService.login(
          username: _usernameController.text,
          password: _passwordController.text);

      setState(() => isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FieldManagementScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginDesign(
          onHomePressed: () => Navigator.pop(context),
          onLoginPressed: _login,
          usernameController: _usernameController,
          passwordController: _passwordController,
          formKey: _formKey,
          isLoading: isLoading
      ),
    );
  }
}

