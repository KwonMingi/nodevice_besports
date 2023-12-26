import 'package:flutter/material.dart';

class ErrDialog extends StatelessWidget {
  final String errMessage;

  const ErrDialog({
    super.key,
    required this.errMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('경고'),
      content: Text(errMessage), // Remove const here
      actions: <Widget>[
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.of(context).pop(); // 대화 상자 닫기
          },
        ),
      ],
    );
  }
}
