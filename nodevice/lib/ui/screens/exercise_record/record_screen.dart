import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/ui/screens/exercise_record/record_view_model.dart';
import 'package:nodevice/ui/widgets/rest_time_modal.dart';
import 'package:nodevice/ui/widgets/text_filds.dart';

class RecordScreen extends StatefulWidget {
  final int setCount;
  final String exerciseType;
  final int restTime;

  const RecordScreen({
    super.key,
    required this.setCount,
    required this.exerciseType,
    required this.restTime,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repController = TextEditingController();
  late final RecordViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RecordViewModel(
      setCount: widget.setCount,
      exerciseType: widget.exerciseType,
      restTime: widget.restTime,
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    repController.dispose();
    super.dispose();
  }

  void saveSetData() async {
    if (viewModel.currentSet < widget.setCount - 1) {
      // 마지막 세트가 아니면 휴식 시간 모달 표시
      await showRestTimeModal(context, widget.restTime);
    }
    // 데이터 저장 로직 실행
    setState(() {
      viewModel.saveSetData(weightController.text, repController.text);
      weightController.clear();
      repController.clear();
    });
  }

  Future<void> showRestTimeModal(BuildContext context, int restTime) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return RestTimeModal(restTime: restTime);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (viewModel.currentSet < widget.setCount) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  '세트 ${viewModel.currentSet + 1} / ${widget.setCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9F7BFF),
                  ),
                ),
              ),
              CustomTextField(
                controller: weightController,
                labelText: '무게',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: repController,
                labelText: '횟수',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveSetData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF9F7BFF),
                ),
                child: const Text('저장'),
              ),
            ],
            if (viewModel.currentSet >= widget.setCount) ...[
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '모든 세트 완료!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9F7BFF),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // GoRouter를 사용하여 특정 경로로 이동
                      context.pushReplacement('/home');
                    },
                    child: const Text('홈화면'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // GoRouter를 사용하여 특정 경로로 이동
                      context.pop();
                    },
                    child: const Text('홈화면'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
