import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        context.replace(routeName);
      },
      child: Text(name),
    );
  }
}
