// exercise_set_list_tile.dart
import 'package:flutter/material.dart';
import 'package:nodevice/data_struct/set_data.dart';

class ExerciseSetListTile extends StatelessWidget {
  final int setNum;
  final SetData set;

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
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // '무게'와 '횟수' 텍스트
          Text('무게: ${set.weight} kg'),
          const SizedBox(width: 15), // '무게'와 '횟수' 사이의 간격
          Text('횟수: ${set.reps} 회'),

          const Spacer(), // 남은 공간을 채우는 위젯

          // '시간' 텍스트
          Text(
            set.time,
            style: const TextStyle(
              fontSize: 12, // 시간을 작게 표시
              color: Colors.grey, // 시간의 색상을 회색으로 설정
            ),
          ),
        ],
      ),
    );
  }
}
