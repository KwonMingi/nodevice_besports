import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/on_memory_data.dart';
import 'package:nodevice/ui/screens/display_record/select_exercise_equipment_screen.dart';
import 'package:nodevice/ui/screens/exercise_record/exercise_screen.dart';

class CustomAddExerciseWidget extends StatelessWidget {
  final String date;
  const CustomAddExerciseWidget({Key? key, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
            width: 210,
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.appGray,
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                border: Border.all(
                  color: CustomColors.appGreen,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  date.isEmpty
                      ? "" // If date is empty, display an empty string
                      : "오늘의 볼륨: ${ExerciseStatus.user.calculateTotalVolume(date)}",
                  style: TextStyle(
                    color: Theme.of(context).canvasColor, // Text color
                    fontSize: 14, // Text font size
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const SelectExerciseEquipmentScreenState(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    CustomColors.appGreen, // ElevatedButton의 배경색 설정

                elevation: 0, // 그림자 제거
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text(
                "+운동 추가하기",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
