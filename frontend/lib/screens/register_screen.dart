import 'package:flutter/material.dart';
import 'package:frontend/constants/role_type.dart';
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

  // Input controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  RoleType? _roleType;

  // Field keys
  final _usernameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _cityFieldKey = GlobalKey<FormFieldState>();
  final _roleFieldKey = GlobalKey<FormFieldState<RoleType>>();

  // Focus nodes
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _cityFocus = FocusNode();

  // Autocomplete city controller
  late final TextEditingController _autocompleteCityController;

  // UI state
  bool isLoading = false;

  // Validation states
  bool usernameAvailable = true;
  bool emailAvailable = true;

  Timer? _debounce;

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username required';
    if (!usernameAvailable) return 'Username already taken';
    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email required';
    final regex = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    if (!regex.hasMatch(email)) return 'Invalid email format';
    if (!emailAvailable) return 'Email already in use';
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password required';
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[^A-Za-z\d])[A-Za-z\d\S]{8,}$');
    return (regex.hasMatch(password)) ? null : 'Min 8 chars, 1 uppercase, 1 special char';
  }

  String? _validateCity(String? city) {
    if (city == null || city.isEmpty) return 'City required';
    return null;
  }

  String? _validateRole(RoleType? role) {
    if (role == null) return 'Role required';
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        bool success = await AuthService.register(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          city: _cityController.text.trim(),
          role: _roleType!.name.toUpperCase(), // Ensure it's not null due to form validation
        );

        if (!mounted) return;

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _autocompleteCityController = TextEditingController(text: _cityController.text);
    _autocompleteCityController.addListener(() {
      _cityController.text = _autocompleteCityController.text;
    });

    _usernameFocus.addListener(() {
      if (!_usernameFocus.hasFocus) {
        _checkUsernameAsync();
      }
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _checkEmailAsync();
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        _passwordFieldKey.currentState?.validate();
      }
    });

    _cityFocus.addListener(() {
      if (!_cityFocus.hasFocus) {
        _cityFieldKey.currentState?.validate();
      }
    });
  }

  Future<void> _checkUsernameAsync() async {
    final name = _usernameController.text.trim();
    if (name.isNotEmpty) {
      try {
        final available = await AuthService.checkUsernameAvailable(name);
        if (mounted) {
          setState(() {
            usernameAvailable = available;
            _usernameFieldKey.currentState?.validate();
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            usernameAvailable = false;
            _usernameFieldKey.currentState?.validate();
          });
        }
      }
    }
  }

  Future<void> _checkEmailAsync() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        final available = await AuthService.checkEmailAvailable(email);
        if (mounted) {
          setState(() {
            emailAvailable = available;
            _emailFieldKey.currentState?.validate();
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            emailAvailable = false;
            _emailFieldKey.currentState?.validate();
          });
        }
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
            child: Text("City:", style: TextStyle(color: Colors.white, fontSize: 16)),
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

  void onRoleChanged(RoleType? role) {
    setState(() => _roleType = role);
    _roleFieldKey.currentState?.validate();
  }

  String? roleValidator(RoleType? value) {
    return _validateRole(value);
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<RoleType>(
      key: _roleFieldKey,
      value: _roleType,
      dropdownColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Role",
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: RoleType.values.map((role) {
        return DropdownMenuItem<RoleType>(
          value: role,
          child: Text(role.name, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onRoleChanged,
      validator: roleValidator,
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
          onBackPressed: () => Navigator.pop(context),
          onRegisterPressed: _register,
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          cityController: _cityController,
          role: _roleType,
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
          roleFieldKey: _roleFieldKey,
          roleValidator: _validateRole,
          onRoleChanged: onRoleChanged,

        ),
      ),
    );
  }
}
