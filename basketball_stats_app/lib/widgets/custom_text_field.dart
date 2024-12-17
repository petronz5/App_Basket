import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  CustomTextField({
    required this.label,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue, // Utilizza initialValue se fornito
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
