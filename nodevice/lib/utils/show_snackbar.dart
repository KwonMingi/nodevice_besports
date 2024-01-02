import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';

class SnackbarManager {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(String message, {Color? textColor}) {
    final effectiveTextColor = textColor ?? custom_colors.appColor;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: effectiveTextColor),
      ),
      backgroundColor: Colors.white,
    );

    // ScaffoldMessenger의 현재 상태를 사용하여 스낵바를 표시
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    }
  }
}
