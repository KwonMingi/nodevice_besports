import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/ui/screens/display_record/history_view_model.dart';
import 'package:nodevice/ui/screens/display_record/widgets/custom_add_exercise_widget.dart';
import 'package:nodevice/ui/widgets/exercise_set_list_title/exercise_set_list_title.dart';

class HistoryScreen extends StatefulWidget {
  final String date;

  const HistoryScreen({super.key, required this.date});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HistoryViewModel(date: widget.date);
    viewModel.loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.exercisesOnDate.isEmpty) {
      return Scaffold(
        body: Container(
          color: CustomColors.appDarkColor,
          child: Column(
            children: [
              const CustomAddExerciseWidget(date: ""),
              Center(
                child: Text(
                  '운동 기록이 없습니다!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: CustomColors.appDarkColor,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            viewModel.loadExercises();
          });
        },
        child: Column(
          children: [
            CustomAddExerciseWidget(date: widget.date),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                itemCount: viewModel.exercisesOnDate.length,
                itemBuilder: (context, index) {
                  final exercise = viewModel.exercisesOnDate[index];

                  List<Widget> setTiles = [];
                  for (int i = 0; i < exercise.setDatas.length; i++) {
                    SetData setData = exercise.setDatas[i];
                    setTiles.add(
                      ExerciseSetListTile(
                        setNum: i + 1,
                        set: setData,
                        userID: getCurrentUserId()!,
                        date: widget.date,
                        exerciseType: exercise.exerciseType,
                        onUpdate: () {
                          setState(() {
                            viewModel.refreshExercises();
                          });
                        },
                        isFirst: i == 0,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: setTiles,
                      ),
                      const SizedBox(height: 1),
                      Container(
                        decoration: const BoxDecoration(
                          color: CustomColors.appGray,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\"${exercise.exerciseType}\"총 볼륨: ${viewModel.getVolume(exercise).toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              Text(
                                "예상 1RM: ${viewModel.getMaxOneRM(exercise).toStringAsFixed(0)}",
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // 여기에서 원하는 만큼의 공간을 추가
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
