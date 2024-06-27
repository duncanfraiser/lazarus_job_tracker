import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class ReusableFormCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String? hintText;
  final TextInputType keyboardType; // Added this parameter

  const ReusableFormCard({
    super.key,
    required this.icon,
    required this.title,
    required this.controller,
    required this.validator,
    required this.keyboardType, // Added this parameter
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Consistent vertical padding
      child: Card(
        color: AppStyles.cardBackgroundColor,
        elevation: AppStyles.cardElevation,
        shape: AppStyles.cardShape,
        child: Padding(
          padding: AppStyles.cardPadding,
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: AppStyles.cardIconSize),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  validator: validator,
                  keyboardType: keyboardType, // Added this parameter
                  style: AppStyles.cardSubtitleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: title,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
