import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryDropdownButton extends StatefulWidget {
  final Icon? icon;
  String? dropdownValue;
  final String label;
  final List brand;
  Function(dynamic) onChanged;
  PrimaryDropdownButton(
      {super.key,
      required this.icon,
      required this.dropdownValue,
      required this.brand,
      required this.label,
      required this.onChanged});

  @override
  State<PrimaryDropdownButton> createState() => _PrimaryDropdownButtonState();
}

class _PrimaryDropdownButtonState extends State<PrimaryDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.label;
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      hint: widget.dropdownValue == ""
          ? Text(
              widget.label,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            )
          : Text(widget.dropdownValue!),
      items: widget.brand.map((val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: widget.onChanged,
      icon: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(Icons.arrow_circle_down_sharp)),
      iconEnabledColor: Colors.white,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      dropdownColor: Colors.white,
      isExpanded: true,
    );
  }
}
