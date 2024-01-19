import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Color labelColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final bool isObscure; // 추가된 부분
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.labelColor,
    required this.borderColor,
    required this.focusedBorderColor,
    this.isObscure = false, // 추가된 부분, 기본값은 false
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // textAlign: TextAlign.center,
      obscureText: isObscure, // 추가된 부분
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            width: 1,
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            width: 1,
            color: focusedBorderColor,
          ),
        ),
      ),
    );
  }
}
