import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import '../design/registration_design.dart';
import 'login_screen.dart';
import 'dart:async';

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
  //late means: I promise this variable will be initialized before I use it.
  late final TextEditingController _autocompleteCityController;


  bool isLoading = false;
  bool usernameAvailable = true;

  Timer? _debounce;

  // Regex-based validators
  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[^A-Za-z\d])[A-Za-z\d\S]{8,}$');
    return regex.hasMatch(password);
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(email);
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        bool success = await AuthService.register(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          city: _cityController.text,
        );

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username required';
    if (!usernameAvailable) return 'Username already taken';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    return isValidEmail(value) ? null : 'Invalid email format';
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password required';
    return isValidPassword(value)
        ? null
        : 'Min 8 chars, 1 uppercase, 1 special char';
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) return 'City required';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _autocompleteCityController = TextEditingController(text: _cityController.text);
    _autocompleteCityController.addListener((){
      _cityController.text = _autocompleteCityController.text;
    });

    _usernameController.addListener(() {
      // Trigger immediate validation for the username field (to clear old errors while waiting)
      _formKey.currentState?.validate();

      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _checkUsernameAsync();
      });
    });
  }

  Future<void> _checkUsernameAsync() async {
    final name = _usernameController.text;
    if (name.isNotEmpty) {
      final available = await AuthService.checkUsernameAvailable(name);
      if (mounted) {
        setState(() => usernameAvailable = available);

        //Trigger form validation to show errors
        _formKey.currentState?.validate();
      }
    }
  }

  Widget _buildAutocompleteCityField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 90,
            child: Text(
              "City:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return await AuthService.fetchCitySuggestions(textEditingValue.text);
              },
              onSelected: (String selection) {
                _cityController.text = selection;
              },
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                // One-way sync: _cityController updates from user edits
                if (textEditingController.text != _cityController.text) {
                  textEditingController.text = _cityController.text;
                  textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textEditingController.text.length),
                  );
                }

                textEditingController.addListener(() {
                  if (_cityController.text != textEditingController.text) {
                    _cityController.text = textEditingController.text;
                  }
                });

                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: _validateCity,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _autocompleteCityController.dispose();
    _debounce?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: RegistrationDesign(
          onLoginPressed: () => Navigator.pop(context),
          onRegisterPressed: _register,
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          cityController: _cityController,
          isLoading: isLoading,
          usernameValidator: _validateUsername,
          emailValidator: _validateEmail,
          passwordValidator: _validatePassword,
          cityValidator: _validateCity,
          customCityField: _buildAutocompleteCityField(),
        ),
      ),
    );
  }
}
