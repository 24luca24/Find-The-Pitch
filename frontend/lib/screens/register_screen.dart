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

  //Input controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();

  //Declaring individual keys for validate fields
  final _usernameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _cityFieldKey = GlobalKey<FormFieldState>();

  //Declaring focus node to trigger error after focus switch from a field to another
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _cityFocus = FocusNode();

  //late means: I promise this variable will be initialized before I use it.
  late final TextEditingController _autocompleteCityController;

  //Toggle loading spinner/UI state
  bool isLoading = false;

  //Store the results of the async username check
  bool usernameAvailable = true;

  //Delay used to fire the username check to reduce API calls while typing
  Timer? _debounce;

  //Field controls

    //Check if field username is null or contains a name already in the db
    String? _validateUsername(String? value) {
      if (value == null || value.isEmpty) return 'Username required';
      if (!usernameAvailable) return 'Username already taken';
      return null;
    }

    //TODO: improve how I check validity of a mail.
    String? _validateEmail(String? email) {
      if (email == null || email.isEmpty) return 'Email required';
      final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
      return (regex.hasMatch(email)) ? null : 'Invalid email format';
    }

    //Check if password contain 8 character, 1 Uppercase, 1 special character
    String? _validatePassword(String? password) {
      if (password == null || password.isEmpty) return 'Password required';
      final regex = RegExp(r'^(?=.*[A-Z])(?=.*[^A-Za-z\d])[A-Za-z\d\S]{8,}$');
      return (regex.hasMatch(password)) ? null :'Min 8 chars, 1 uppercase, 1 special char';
    }

    //Only check if there is something in the controller since city are preloaded from db
    String? _validateCity(String? value) {
      if (value == null || value.isEmpty) return 'City required';
      return null;
    }

  //Function to be called on the register button. Check if all field are valid,
  //call the Authservice -> the API and send to the db the data.
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

  //Initialize autocomplete field, timer and error state
  @override
  void initState() {
    super.initState();
    _autocompleteCityController = TextEditingController(text: _cityController.text);
    _autocompleteCityController.addListener((){
      _cityController.text = _autocompleteCityController.text;
    });

    //Attach debounce to username text changes (this run every 500 millisecond)
    // _usernameController.addListener(() {
    //   if (_debounce?.isActive ?? false) _debounce!.cancel();
    //   _debounce = Timer(const Duration(milliseconds: 500), () {
    //     _checkUsernameAsync();
    //   });
    // });

    //This run after the focus change
    _usernameFocus.addListener(() {
      if (!_usernameFocus.hasFocus) {
        _usernameFieldKey.currentState?.validate();
        // Optional: Trigger username check on blur too (no debounce here)
        _checkUsernameAsync();
      }
    });

    _emailFocus.addListener((){
      if(!_emailFocus.hasFocus) {
        _emailFieldKey.currentState?.validate();
      }
    });

    _passwordFocus.addListener((){
      if(!_passwordFocus.hasFocus) {
      _passwordFieldKey.currentState?.validate();
      }
    });

    _cityFocus.addListener((){
      if(!_cityFocus.hasFocus) {
        _cityFieldKey.currentState?.validate();
      }
    });
  }

  //Check if username already exist in the db
  Future<void> _checkUsernameAsync() async {
    final name = _usernameController.text;
    if (name.isNotEmpty) {
      try {
        final available = await AuthService.checkUsernameAvailable(name);
        if (mounted) {
          usernameAvailable = available;

          //Trigger form validation to show errors
          setState(() {
            _usernameFieldKey.currentState?.validate();
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            usernameAvailable = false; //Assume non-available if API fails
          });

          setState(() {
            _usernameFieldKey.currentState?.validate();
          });

        }
      }

    }
  }

  //Widget to create autocomplete city field
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
                    fillColor: Colors.black.withValues(alpha: 0.3),
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

  //Prevent memory leak
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

  //Handles design, classing the design class constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: RegistrationDesign(
          onBackPressed: () => Navigator.pop(context),
          onRegisterPressed: _register,
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          cityController: _cityController,
          isLoading: isLoading,
          customCityField: _buildAutocompleteCityField(),
          usernameFocusNode: _usernameFocus,
          passwordFocusNode: _passwordFocus,
          cityFocusNode: _cityFocus,
          emailFocusNode: _emailFocus,
          usernameValidator: _validateUsername,
          passwordValidator: _validatePassword,
          emailValidator: _validateEmail,
          cityValidator: _validateCity,
          usernameFieldKey: _usernameFieldKey,
          passwordFieldKey: _passwordFieldKey,
          emailFieldKey: _emailFieldKey,
          cityFieldKey: _cityFieldKey,
        ),
      ),
    );
  }
}
