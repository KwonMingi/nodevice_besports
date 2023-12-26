import 'package:flutter/material.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/ui/screens/exerciseRecord/record_view_model.dart';
import 'package:nodevice/ui/widgets/exercise_list_view.dart';
import 'package:nodevice/ui/widgets/custom_buttons/push_button.dart';
import 'package:nodevice/ui/widgets/text_filds.dart';

class RecordScreen extends StatefulWidget {
  final int setCount;
  final String exerciseType;

  const RecordScreen({
    super.key,
    required this.setCount,
    required this.exerciseType,
  });

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repController = TextEditingController();
  late final RecordViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RecordViewModel(
        setCount: widget.setCount, exerciseType: widget.exerciseType, uid: '');
  }

  @override
  void dispose() {
    weightController.dispose();
    repController.dispose();
    super.dispose();
  }

  void saveSetData() {
    setState(() {
      viewModel.saveSetData(weightController.text, repController.text);
      weightController.clear();
      repController.clear();
    });
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
              CustomTextField(controller: weightController, labelText: '무게'),
              const SizedBox(height: 10),
              CustomTextField(controller: repController, labelText: '횟수'),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PushReplaceButton(routeName: '/home'),
                  SizedBox(width: 10),
                  PushReplaceButton(routeName: '/exercise')
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.user.exercises.length, // 운동의 수
                  itemBuilder: (context, index) {
                    Exercise exercise = viewModel.user.exercises[index];
                    return ExerciseListView(exercises: [
                      exercise
                    ]); // Pass only the current exercise
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
