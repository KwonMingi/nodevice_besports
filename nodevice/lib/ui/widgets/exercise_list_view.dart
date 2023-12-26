import 'package:flutter/material.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/ui/widgets/exercise_card.dart';

class ExerciseListView extends StatelessWidget {
  final List<Exercise> exercises;

  const ExerciseListView({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exercises.length, // 운동의 수
      itemBuilder: (context, index) {
        Exercise exercise = exercises[index];
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(), // 중첩 스크롤 방지
          shrinkWrap: true,
          itemCount: exercise.setDatas.length, // 운동별 세트 수
          itemBuilder: (context, setIndex) {
            int setNum = setIndex + 1;
            SetData setData = exercise.setDatas[setIndex];
            return ExerciseCard(setNum: setNum, setData: setData);
          },
        );
      },
    );
  }
}
