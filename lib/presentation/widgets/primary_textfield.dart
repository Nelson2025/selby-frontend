/* This is Primary TextField Widget*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selby/core/ui.dart';

class PrimaryTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Icon? icon;
  final String? prefixText;
  final dynamic maxLength;

  const PrimaryTextField(
      {super.key,
      required this.labelText,
      this.controller,
      this.obscureText = false,
      this.validator,
      this.initialValue,
      this.onChanged,
      this.keyboardType,
      this.icon,
      this.prefixText,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: TextStyle(fontSize: 14, color: AppColors.textLight),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelText: labelText,
        prefixIcon: icon,
        prefixText: prefixText,
        prefixStyle: const TextStyle(fontSize: 16.5, color: Colors.black),
      ),
    );
  }
}
