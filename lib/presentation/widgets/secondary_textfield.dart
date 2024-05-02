import 'package:flutter/material.dart';

class SecondaryTextField extends StatelessWidget {
  final String labelText;
  final Icon? icon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool? readOnly;
  const SecondaryTextField(
      {super.key,
      required this.labelText,
      this.icon,
      this.controller,
      this.onChanged,
      this.initialValue,
      this.validator,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      cursorColor: Colors.black,
      readOnly: readOnly == null ? false : true,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: labelText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
