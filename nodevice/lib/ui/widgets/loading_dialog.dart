// loading_dialog.dart

import 'package:flutter/material.dart';

Future<void> showLoadingDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // 사용자가 다이얼로그 밖을 터치해도 닫히지 않도록 설정
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Loading..."),
          ],
        ),
      );
    },
  );
}
