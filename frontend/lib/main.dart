import 'package:flutter/material.dart';
import 'package:frontend/screens/register_screen.dart';

void main() {

  //Function that lunch the app -> takes a widget (UI component) and renders it on the screen
  runApp(const MyApp());
}

//StateLess Widget -> its content does not change
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find the Pitch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const RegisterScreen(),
    );
  }
}
