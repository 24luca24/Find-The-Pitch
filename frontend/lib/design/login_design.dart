import 'package:flutter/material.dart';
import 'package:frontend/constants/image_path.dart';
import '../widgets/primary_button.dart';

class LoginDesign extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onHomePressed;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  //object that uniquely identifies a form and allows you to validate or reset it programmatically
  final GlobalKey<FormState> formKey;
  final bool isLoading;

  const LoginDesign({
    super.key,
    required this.onLoginPressed,
    required this.onHomePressed,
    required this.usernameController,
    required this.passwordController,
    required this.formKey,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    //Allows to place widgets on top of each other (like layers) / container can have only one child
    return Stack(
      children: [
        Opacity(
          opacity: 0.9,
          child: Image.asset(
            ImagePath.background_login,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        //Back Home button
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onHomePressed,
          ),
        ),

        //Login form
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
                    _buildLabeledField(
                        "Password", passwordController,
                        obscure: true,
                        validator: (val) {
                          if (val == null || val.length < 8) return "Min 8 characters";
                          return null;
                        }),
                    const SizedBox(height: 24),
                    isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 200,
                          child: PrimaryButton(text: "Login", onPressed: onLoginPressed),
                    ),
                  ],
                ),)
            ),
          )
        )
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
                )
              ),
            ))
        ],
      ),
    );
  }
}