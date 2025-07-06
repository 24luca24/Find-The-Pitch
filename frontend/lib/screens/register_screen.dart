import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import '../design/registration_design.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();

  bool isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      bool success = await AuthService.register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        city: _cityController.text,
      );

      setState(() => isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
      body: RegistrationDesign(
        onLoginPressed: () => Navigator.pop(context),
        onRegisterPressed: _register,
        usernameController: _usernameController,
        emailController: _emailController,
        passwordController: _passwordController,
        cityController: _cityController,
        formKey: _formKey,
        isLoading: isLoading,
      ),
    );
  }
}
