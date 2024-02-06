import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/screens/exercise_record/buttom_widget.dart';
import 'package:nodevice/ui/screens/exercise_record/record_screen.dart';
import 'package:nodevice/ui/widgets/err_dialog.dart';
import 'package:nodevice/ui/widgets/text_filds.dart';

class ExerciseScreen extends StatefulWidget {
  final String exerciseType;
  const ExerciseScreen({super.key, required this.exerciseType});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _setCountController = TextEditingController();
  final TextEditingController _restTimeController = TextEditingController();

  int setCount = 0;

  @override
  void initState() {
    super.initState();
    _setCountController.text = '10';
    _restTimeController.text = '30';
  }

  void _handleExerciseStart() {
    // 세트 수와 운동 종류가 모두 입력되었는지 확인
    if (_setCountController.text.isEmpty || _restTimeController.text.isEmpty) {
      // 하나라도 입력되지 않았을 경우, 경고 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrDialog(
            errMessage: '세트 수, 휴식 시간을 모두 입력해야 합니다.',
          );
        },
      );
    } else {
      // 모두 입력되었을 경우, 다음 화면으로 이동
      int restTime = int.tryParse(_restTimeController.text) ?? 0;
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => RecordScreen(
            setCount: int.tryParse(_setCountController.text) ?? 0,
            exerciseType: widget.exerciseType,
            restTime: restTime,
          ),
        ),
      )
          .then((_) {
        // 화면 이동 후 텍스트 필드 초기화
        _setCountController.clear();
        _restTimeController.clear(); // 휴식 시간 필드도 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RSizes s = RSizes(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: CustomColors.appDarkColor, // 상단 상태 바 색상 설정
        systemNavigationBarColor: CustomColors.appDarkColor, // 하단 네비게이션 바 색상 설정
        statusBarIconBrightness:
            Brightness.light, // 상태 바 아이콘 밝기 설정 (어두운 색상의 배경에 맞게 밝게)
        systemNavigationBarIconBrightness:
            Brightness.light, // 네비게이션 바 아이콘 밝기 설정 (어두운 색상의 배경에 맞게 밝게)
      ),
      child: Scaffold(
        backgroundColor: CustomColors.appDarkColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '운동할 세트 수를 입력해주세요!',
                style: TextStyle(
                  color: CustomColors.appGreen, // 텍스트 색상
                  fontSize: 20, // 글꼴 크기
                  fontWeight: FontWeight.bold, // 글꼴 두께
                ),
              ),
              const SizedBox(height: 20),
              SizedCustomTextField(
                controller: _setCountController,
                labelText: '세트수',
                height: s.rSize("height", 60),
                width: s.rSize("height", 300),
              ),
              SetCountAdjustButtons(
                setCountController: _setCountController,
                updateParentState: () {
                  setState(() {});
                },
                adjustments: const [-5, -1, 1, 5], // 사용자 정의 숫자
              ),
              const SizedBox(
                height: 20,
              ),
              SizedCustomTextField(
                controller: _restTimeController,
                labelText: '휴식시간',
                height: s.rSize("height", 60),
                width: s.rSize("height", 300),
              ),
              SetCountAdjustButtons(
                setCountController: _restTimeController,
                updateParentState: () {
                  setState(() {});
                },
                adjustments: const [-30, -10, 10, 30], // 사용자 정의 숫자
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _handleExerciseStart();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appGreen),
                child: const Text(
                  '운동 시작 !',
                  style: TextStyle(color: CustomColors.appDarkColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
