import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    // Limit max width of button to 400 px or 80% of screen width, whichever is smaller
    double maxButtonWidth = deviceWidth * 0.8;
    if (maxButtonWidth > 400) maxButtonWidth = 400;

    // Use fixed vertical padding for better control
    double verticalPadding = 14;

    // Font size: scale for small screens but cap on big screens
    double fontSize = deviceWidth < 400 ? deviceWidth * 0.045 : 18;

    return Center(
      child: Container(
        width: maxButtonWidth,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.lightBlue.shade700; // hover color
              }
              return Colors.lightBlue.shade400; // normal color
            }),
            foregroundColor: MaterialStateColor.resolveWith((_) => Colors.white),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: verticalPadding),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevation: MaterialStateProperty.all(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
