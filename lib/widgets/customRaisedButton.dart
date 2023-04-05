// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String buttonText;

  const CustomRaisedButton({super.key, required this.buttonText});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8CBBF1),
            Color(0xFF8CBBF1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
