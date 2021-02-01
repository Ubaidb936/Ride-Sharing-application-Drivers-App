import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {

  CustomInputField({this.textController, this.textInputType, this.hintText, this.obscureText, this.icon });

  final TextEditingController textController;
  final TextInputType textInputType;
  final String hintText;
  final obscureText;
  final icon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
          prefixText: (hintText == 'PhoneNumber')? "+91": "",
          prefixIcon: icon,
          border: InputBorder.none,
          hintText: hintText,
          fillColor: Colors.grey[200],
          filled: true
      ),
    );
  }
}