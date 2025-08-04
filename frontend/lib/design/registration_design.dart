import 'package:flutter/material.dart';
import 'package:frontend/constants/image_path.dart';
import 'package:frontend/constants/role_type.dart';
import '../widgets/primary_button.dart';

class RegistrationDesign extends StatelessWidget {
  // Buttons
  final VoidCallback onRegisterPressed;
  final VoidCallback onBackPressed;

  // Controllers
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController cityController;

  // Form field keys
  final GlobalKey<FormFieldState>? usernameFieldKey;
  final GlobalKey<FormFieldState>? passwordFieldKey;
  final GlobalKey<FormFieldState>? emailFieldKey;
  final GlobalKey<FormFieldState>? cityFieldKey;
  final GlobalKey<FormFieldState<RoleType>>? roleFieldKey;

  // Focus nodes
  final FocusNode? usernameFocusNode;
  final FocusNode? emailFocusNode;
  final FocusNode? passwordFocusNode;
  final FocusNode? cityFocusNode;

  // Validators
  final String? Function(String?)? usernameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? passwordValidator;
  final String? Function(String?)? cityValidator;
  final String? Function(RoleType?)? roleValidator;

  // Role dropdown
  final RoleType? role;
  final void Function(RoleType?) onRoleChanged;

  // City field (custom autocomplete)
  final Widget? customCityField;

  final bool isLoading;

  const RegistrationDesign({
    super.key,
    required this.onBackPressed,
    required this.onRegisterPressed,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.cityController,
    required this.isLoading,
    required this.customCityField,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.cityFocusNode,
    required this.emailFocusNode,
    required this.usernameValidator,
    required this.passwordValidator,
    required this.cityValidator,
    required this.emailValidator,
    required this.usernameFieldKey,
    required this.passwordFieldKey,
    required this.cityFieldKey,
    required this.emailFieldKey,
    required this.role,
    required this.onRoleChanged,
    required this.roleFieldKey,
    required this.roleValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Opacity(
          opacity: 0.9,
          child: Image.asset(
            ImagePath.backgroundRegistration,
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
            onPressed: onBackPressed,
          ),
        ),

        // Form content
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLabeledField(
                    "Username",
                    usernameController,
                    focusNode: usernameFocusNode,
                    validator: usernameValidator,
                    fieldKey: usernameFieldKey,
                  ),
                  _buildLabeledField(
                    "Email",
                    emailController,
                    focusNode: emailFocusNode,
                    validator: emailValidator,
                    fieldKey: emailFieldKey,
                  ),
                  _buildLabeledField(
                    "Password",
                    passwordController,
                    obscure: true,
                    focusNode: passwordFocusNode,
                    validator: passwordValidator,
                    fieldKey: passwordFieldKey,
                  ),
                  customCityField ??
                      _buildLabeledField(
                        "City",
                        cityController,
                        focusNode: cityFocusNode,
                        validator: cityValidator,
                        fieldKey: cityFieldKey,
                      ),
                  const SizedBox(height: 8),
                  _buildRoleDropdown(),
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
        FocusNode? focusNode,
        Key? fieldKey,
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
              focusNode: focusNode,
              obscureText: obscure,
              validator: validator,
              key: fieldKey,
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

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 90,
            child: Text(
              "Role:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<RoleType>(
              key: roleFieldKey,
              value: role,
              dropdownColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: RoleType.values.map((role) {
                return DropdownMenuItem<RoleType>(
                  value: role,
                  child: Text(
                    role.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: onRoleChanged,
              validator: roleValidator,
            ),
          ),
        ],
      ),
    );
  }
}
