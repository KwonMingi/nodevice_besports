// exercise_set_list_tile.dart
import 'package:flutter/material.dart';

class ExerciseSetListTile extends StatelessWidget {
  final int setNum;
  final Map<String, int> set;

  const ExerciseSetListTile({
    Key? key,
    required this.setNum,
    required this.set,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '세트 $setNum',
        style: const TextStyle(color: Color(0xFF9F7BFF)),
      ),
      subtitle: Text('무게: ${set['weight']} kg, 횟수: ${set['reps']} 회'),
    );
  }
}
