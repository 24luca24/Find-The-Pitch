import 'package:flutter/material.dart';
import 'package:frontend/constants/image_path.dart';
import '../widgets/primary_button.dart';

class RegistrationDesign extends StatelessWidget {
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginPressed;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController cityController;
  final bool isLoading;

  final String? Function(String?) usernameValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) passwordValidator;
  final String? Function(String?) cityValidator;

  final Widget? customCityField;

  const RegistrationDesign({
    super.key,
    required this.onLoginPressed,
    required this.onRegisterPressed,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.cityController,
    required this.isLoading,
    required this.usernameValidator,
    required this.passwordValidator,
    required this.cityValidator,
    required this.emailValidator,
    required this.customCityField,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Opacity(
          opacity: 0.9,
          child: Image.asset(
            ImagePath.background_registration,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Back button
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onLoginPressed,
          ),
        ),

        // Form content (no longer wraps Form here)
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLabeledField("Username", usernameController, validator: usernameValidator),
                  _buildLabeledField("Email", emailController, validator: emailValidator),
                  _buildLabeledField("Password", passwordController, obscure: true, validator: passwordValidator),
                  customCityField ?? _buildLabeledField("City", cityController, validator: cityValidator),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: 200,
                    child: PrimaryButton(
                      text: "Register",
                      onPressed: onRegisterPressed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledField(
      String label,
      TextEditingController controller, {
        bool obscure = false,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
