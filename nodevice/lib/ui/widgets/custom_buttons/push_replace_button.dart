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
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }

        // GoRouter를 사용하여 특정 경로로 이동
        if (name == "홈화면") {
          context.pop();
          context.pop();
          context.pop();
        } else {
          // 이전 화면으로 돌아가기 (GoRouter 사용 시 pop은 기본 Navigator.pop과 동일하게 작동)
          context.pop();
        }
      },
      child: Text(name),
    );
  }
}
