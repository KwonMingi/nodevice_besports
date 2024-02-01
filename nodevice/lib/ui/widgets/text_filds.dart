import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Color labelColor;
  final Color borderColor;
  final double borderWidth;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.labelColor = CustomColors.appGreen,
    this.borderColor = CustomColors.appGreen,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
    );
  }
}

class SizedCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double height;
  final double width;
  final Color labelColor;
  final Color borderColor;
  final double borderWidth;

  const SizedCustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.height,
    required this.width,
    this.labelColor = CustomColors.appGreen,
    this.borderColor = CustomColors.appGreen,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        style: TextStyle(color: Theme.of(context).canvasColor),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: labelColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
      ),
    );
  }
}
