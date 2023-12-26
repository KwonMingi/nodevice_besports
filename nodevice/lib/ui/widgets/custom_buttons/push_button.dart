import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PushReplaceButton extends StatelessWidget {
  final String _routeName;
  const PushReplaceButton({super.key, required routeName})
      : _routeName = routeName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 30,
      child: ElevatedButton(
        // '홈 화면으로 가기' 버튼의 onPressed 이벤트
        onPressed: () {
          context.replace(_routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9F7BFF),
        ),
        child: const Text('다시하기'),
      ),
    );
  }
}
