import 'package:flutter/material.dart';
import 'package:nodevice/constants/rSizes.dart';
import 'package:nodevice/exercise/exerciseRepo/exerciseRepo.dart';
import 'package:nodevice/exercise/views/recordScreen.dart';

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
            SizedBox(
              height: s.rSize("height", 70),
              width: s.rSize("height", 300),
              child: TextField(
                controller: _exerciseTypeController, // 운동 종류 컨트롤러 사용
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF9F7BFF), // 일반 테두리 색상
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF9F7BFF), // 활성화되었을 때 테두리 색상
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF9F7BFF), // 포커스되었을 때 테두리 색상
                      width: 2.0,
                    ),
                  ),
                  labelText: '운동 종류',
                  labelStyle: TextStyle(
                    color: Color(0xFF9F7BFF), // 레이블 텍스트 색상
                  ),
                  // 필요에 따라 텍스트 필드 내부 텍스트 색상도 설정할 수 있습니다.
                  hintStyle: TextStyle(
                    color: Color(0xFF9F7BFF), // 입력 텍스트 색상
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: s.rSize("height", 70), // TextField의 높이
              width: s.rSize("height", 300), // TextField의 너비
              child: TextField(
                controller: _setCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF), width: 2),
                  ),
                  labelText: '세트 수',
                  labelStyle: TextStyle(color: Color(0xFF9F7BFF)),
                  // 필요하다면 텍스트 필드 내 텍스트 색상도 설정할 수 있습니다.
                  // 이를 위해 'style' 속성을 사용합니다.
                  hintStyle: TextStyle(color: Color(0xFF9F7BFF)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 세트 수와 운동 종류가 모두 입력되었는지 확인
                if (_setCountController.text.isEmpty ||
                    _exerciseTypeController.text.isEmpty) {
                  // 하나라도 입력되지 않았을 경우, 경고 메시지 표시
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('경고'),
                        content: const Text('세트 수와 운동 종류를 모두 입력해야 합니다.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop(); // 대화 상자 닫기
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // 모두 입력되었을 경우, 다음 화면으로 이동하고 텍스트 필드 초기화
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordScreen(
                        setCount: int.tryParse(_setCountController.text) ?? 0,
                        exerciseType: _exerciseTypeController.text,
                      ),
                    ),
                  ).then((_) {
                    // 화면 이동 후 텍스트 필드 초기화
                    _setCountController.clear();
                    _exerciseTypeController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9F7BFF),
              ),
              child: const Text('운동 시작 !'),
            ),
          ],
        ),
      ),
    );
  }
}
