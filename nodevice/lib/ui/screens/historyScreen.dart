import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodevice/constants/staticStatus.dart';
import 'package:nodevice/ui/widgets/exerciseSetListTitle.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    if (ExerciseStatus.result.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            '운동 기록이 없습니다!',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9F7BFF),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
        children: ExerciseStatus.result.keys.map((exerciseName) {
          List<Map<String, int>> sets = ExerciseStatus.result[exerciseName]!;
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFF9F7BFF), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // 운동 이름 라벨을 위한 공간 확보
                    ...sets.asMap().entries.map((entry) {
                      int setNum = entry.key + 1;
                      return ExerciseSetListTile(
                        setNum: setNum,
                        set: entry.value,
                      );
                    }).toList(),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  color: ThemeData.light().canvasColor, // 배경색
                  child: Text(
                    exerciseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
