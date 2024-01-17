import 'package:flutter/material.dart';

Widget RoundedTextField({String? label, Color? textColor, controller, isObscure}) {
  return TextField(
      obscureText: isObscure,
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
}