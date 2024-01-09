import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/ui/screens/display_record/history_view_model.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            viewModel.loadExercises();
          });
        },
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
          itemCount: viewModel.exercisesOnDate.length,
          itemBuilder: (context, index) {
            final exercise = viewModel.exercisesOnDate[index];
            double volume = viewModel.getVolume(exercise);
            double maxOneRM = viewModel.getMaxOneRM(exercise);

            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: const Color(0xFF9F7BFF), width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          ...exercise.setDatas.asMap().entries.map((entry) {
                            int setNum = entry.key + 1;
                            SetData setData = entry.value;
                            return ExerciseSetListTile(
                              setNum: setNum,
                              set: setData,
                              userID: getCurrentUserId()!,
                              date: widget.date,
                              exerciseType: exercise.exerciseType,
                              onUpdate: () {
                                // Define what should happen when a set is updated.
                                // For example, reload the data:
                                setState(() {
                                  viewModel.refreshExercises();
                                });
                              },
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
                        color: Theme.of(context).canvasColor,
                        child: Text(
                          exercise.exerciseType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF9F7BFF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("총 볼륨: ${volume.toStringAsFixed(2)}"),
                      Text("예상 1RM: ${maxOneRM.toStringAsFixed(0)}"),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
