import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String message;
  final Color backgroundColor; // 배경색 매개변수 추가
  final Color foregroundColor;
  final Color textColor;

  const CustomSignInButton({
    Key? key,
    required this.onPressed,
    this.width = double.infinity, // 기본값은 무한대
    this.height = 50.0, // 기본 높이
    this.message = '', // 기본 메시지
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue, // 기본 배경색
    this.foregroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        icon: const FaIcon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
        label: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor, // 배경색 사용
        ),
        onPressed: onPressed,
      ),
    );
  }
}
