import 'package:flutter/material.dart';
import 'package:frontend/constants/image_path.dart';
import '../widgets/primary_button.dart';

class WelcomeDesign extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;
  final VoidCallback onGuestPressed;

  const WelcomeDesign({
    super.key,
    required this.onLoginPressed,
    required this.onRegisterPressed,
    required this.onGuestPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Background image with 85% opacity
        Opacity(
          opacity: 0.90,
          child: Image.asset(
            ImagePath.welcome_background, //"assets/images/welcome_background.jpg""
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Foreground content
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Find the Pitch!",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        color: Colors.black54,
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                PrimaryButton(
                  text: "Login",
                  onPressed: onLoginPressed,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: "Register",
                  onPressed: onRegisterPressed,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                    text: "Guest Access",
                    onPressed: onGuestPressed
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
