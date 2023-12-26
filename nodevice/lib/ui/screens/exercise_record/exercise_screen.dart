import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/screens/exercise_record/record_screen.dart';
import 'package:nodevice/ui/widgets/err_dialog.dart';
import 'package:nodevice/ui/widgets/text_filds.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _setCountController = TextEditingController();
  final TextEditingController _exerciseTypeController =
      TextEditingController(); // 운동 종류를 위한 컨트롤러

  int setCount = 0;

  void _handleExerciseStart() {
    // 세트 수와 운동 종류가 모두 입력되었는지 확인
    if (_setCountController.text.isEmpty ||
        _exerciseTypeController.text.isEmpty) {
      // 하나라도 입력되지 않았을 경우, 경고 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrDialog(
            errMessage: '세트 수와 운동 종류를 모두 입력해야 합니다.',
          );
        },
      );
    } else {
      // 모두 입력되었을 경우, 다음 화면으로 이동
      GoRouter.of(context).replace('/record', extra: {
        'setCount': int.tryParse(_setCountController.text) ?? 0,
        'exerciseType': _exerciseTypeController.text
      }).then((_) {
        // 화면 이동 후 텍스트 필드 초기화
        _setCountController.clear();
        _exerciseTypeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RSizes s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '운동할 세트 수를 입력해주세요!',
              style: TextStyle(
                color: Color(0xFF9F7BFF), // 텍스트 색상
                fontSize: 20, // 글꼴 크기
                fontWeight: FontWeight.bold, // 글꼴 두께
              ),
            ),
            const SizedBox(height: 20),
            SizedCustomTextField(
              controller: _exerciseTypeController,
              labelText: '운동 종류',
              height: s.rSize("height", 70),
              width: s.rSize("height", 300),
            ),
            const SizedBox(height: 20),
            SizedCustomTextField(
              controller: _setCountController,
              labelText: '세트수',
              height: s.rSize("height", 70),
              width: s.rSize("height", 300),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleExerciseStart();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F7BFF)),
              child: const Text('운동 시작 !'),
            ),
          ],
        ),
      ),
    );
  }
}
