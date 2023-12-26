import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: custom_colors.appColor), // Black text color
    ),
    backgroundColor: Colors.white, // White background color
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
