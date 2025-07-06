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
  final GlobalKey<FormState> formKey;
  final bool isLoading;

  const RegistrationDesign({
    super.key,
    required this.onLoginPressed,
    required this.onRegisterPressed,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.cityController,
    required this.formKey,
    required this.isLoading,
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

        // Form content
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLabeledField("Username", usernameController, validator: (val) {
                      if (val == null || val.isEmpty) return "Please enter username";
                      return null;
                    }),
                    _buildLabeledField("Email", emailController, validator: (val) {
                      if (val == null || val.isEmpty) return "Please enter email";
                      return null;
                    }),
                    _buildLabeledField("Password", passwordController,
                        obscure: true,
                        validator: (val) {
                          if (val == null || val.length < 6) return "Min 6 characters";
                          return null;
                        }),
                    _buildLabeledField("City", cityController),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: 200, // Narrower button
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