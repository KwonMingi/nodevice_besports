import 'package:flutter/material.dart';
import 'package:nodevice/ui/screens/home_screen/home_screen.dart';

class CustomPushReplaceButton extends StatelessWidget {
  final String routeName;
  final String name;
  final VoidCallback? onPressed;

  const CustomPushReplaceButton({
    super.key,
    required this.routeName,
    required this.name,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (onPressed != null) {
          onPressed!();
        }
        if (name == "홈화면") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(
                initialIndex: 0,
              ),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Text(name),
    );
  }
}
