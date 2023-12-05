import 'package:flutter/material.dart';
import 'package:nodevice/exercise/exerciseModel/exerciseModel.dart';
import 'package:nodevice/exercise/exerciseRepo/exerciseRepo.dart';
import 'package:nodevice/ui/screens/homeScreen.dart';
import 'package:nodevice/exercise/exerciseViewModel/recordViewModel.dart';

class RecordScreen extends StatefulWidget {
  final int setCount; // 전체 세트수
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
  final ExerciseRepo _repo = ExerciseRepo();
  late final RecordViewModel viewModel;
  List<int> set = [];

  @override
  void initState() {
    super.initState();
    viewModel = RecordViewModel(
      setCount: widget.setCount,
      exerciseType: widget.exerciseType,
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    repController.dispose();
    super.dispose();
  }

  void saveSetData() {
    set.add(int.parse(weightController.text));
    set.add(int.parse(repController.text));
    _repo.sendExerciseSet(
      viewModel.exerciseType,
      viewModel.currentSet,
      set,
    );
    setState(() {
      viewModel.saveSetData(weightController.text, repController.text);
      weightController.clear();
      repController.clear();
    });
    set.clear();
    final exerciseSet = _repo.getExerciseSet(viewModel.exerciseType);
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
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '무게',
                  labelStyle: TextStyle(color: Color(0xFF9F7BFF)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: repController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '횟수',
                  labelStyle: TextStyle(color: Color(0xFF9F7BFF)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9F7BFF), width: 2),
                  ),
                ),
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
            ], //             <저장한 후 화면>
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
                  SizedBox(
                    width: 130,
                    height: 30,
                    child: ElevatedButton(
                      // '홈 화면으로 가기' 버튼의 onPressed 이벤트
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(
                              initialIndex: 0,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9F7BFF),
                      ),
                      child: const Text('홈 화면으로 가기'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 130,
                    height: 30,
                    child: ElevatedButton(
                      // '홈 화면으로 가기' 버튼의 onPressed 이벤트
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen(
                                    initialIndex: 1,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9F7BFF),
                      ),
                      child: const Text('다시하기'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.setResults.length,
                  itemBuilder: (context, index) {
                    int setNum = index + 1;
                    Map<String, int> set = viewModel.setResults[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '세트 $setNum',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9F7BFF),
                          ),
                        ),
                        subtitle: Text(
                            '무게: ${set['weight']} kg, 횟수: ${set['reps']} 회'),
                      ),
                    );
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
