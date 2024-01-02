import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PushReplaceButton extends StatelessWidget {
  final String _routeName;
  final String _name;
  const PushReplaceButton({super.key, required routeName, required name})
      : _routeName = routeName,
        _name = name;

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
        child: Text(_name),
      ),
    );
  }
}
