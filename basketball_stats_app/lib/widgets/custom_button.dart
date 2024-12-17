// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50), // Pulsante piena larghezza
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
