import 'package:flutter/material.dart';
import 'package:frontend/design/login_design.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/map_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

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

  //Function associated to login button, allow to change screen if login is successful
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);



      bool success = await AuthService.login(
          username: _usernameController.text,
          password: _passwordController.text);

      setState(() => isLoading = false);

      if (!mounted) return;

        if (success) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.loadToken();
          if(!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MapScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed.")),
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

