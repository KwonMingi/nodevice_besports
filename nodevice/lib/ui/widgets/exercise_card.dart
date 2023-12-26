import 'package:flutter/material.dart';
import 'package:nodevice/data_struct/set_data.dart';

class ExerciseCard extends StatelessWidget {
  final SetData _setData;
  final int _setNum;

  const ExerciseCard({
    super.key,
    required setNum,
    required setData,
  })  : _setNum = setNum,
        _setData = setData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          '세트 $_setNum',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF9F7BFF),
          ),
        ),
        subtitle: Text(
            '시간: ${_setData.time}, 무게: ${_setData.weight} kg, 횟수: ${_setData.reps} 회'),
      ),
    );
  }
}
