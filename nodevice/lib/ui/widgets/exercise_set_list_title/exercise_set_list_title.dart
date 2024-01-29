import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/static_status.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/ui/widgets/exercise_set_list_title/exercise_set_list_title_view_model.dart';

class ExerciseSetListTile extends StatefulWidget {
  final int setNum;
  final SetData set;
  final String userID;
  final String date;
  final String exerciseType;
  final VoidCallback onUpdate;
  final bool isFirst;
  final bool isLast;
  final bool isOnly;

  const ExerciseSetListTile({
    Key? key,
    required this.setNum,
    required this.set,
    required this.userID,
    required this.date,
    required this.exerciseType,
    required this.onUpdate,
    this.isFirst = false,
    this.isLast = false,
    this.isOnly = false,
  }) : super(key: key);

  @override
  State<ExerciseSetListTile> createState() => _ExerciseSetListTileState();
}

class _ExerciseSetListTileState extends State<ExerciseSetListTile> {
  late final ExerciseSetViewModel _viewModel = ExerciseSetViewModel(
    weightController: TextEditingController(
      text: widget.set.weight.toString(),
    ),
    repsController: TextEditingController(
      text: widget.set.reps.toString(),
    ),
  );

  void _showEditDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('세트 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _viewModel.weightController,
                decoration: const InputDecoration(labelText: '무게'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _viewModel.repsController,
                decoration: const InputDecoration(labelText: '횟수'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () async {
                // Map<String, dynamic> updatedData = {
                //   'weight': double.parse(_viewModel.weightController.text),
                //   'reps': int.parse(_viewModel.repsController.text),
                // };
                SetData updateData = SetData(
                    double.parse(_viewModel.weightController.text),
                    int.parse(_viewModel.repsController.text));
                updateData.setTime = widget.set.time;

                ExerciseStatus.user.updateSetDataValues(
                    widget.exerciseType,
                    widget.date,
                    widget.set.time,
                    double.parse(_viewModel.weightController.text),
                    int.parse(_viewModel.repsController.text));

                await _viewModel.updateSetData(widget.userID, widget.date,
                    widget.exerciseType, widget.set.time, updateData.toMap());

                Navigator.of(context).pop();
                widget.onUpdate(); // Call onUpdate to refresh the parent widget
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (widget.isOnly) {
      borderRadius = BorderRadius.circular(15.0);
    } else if (widget.isFirst) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      );
    } else if (widget.isLast) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      );
    } else {
      borderRadius = BorderRadius.zero;
    }

    return GestureDetector(
      onTap: () => _showEditDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: CustomColors.appGray,
          borderRadius: borderRadius, // 동적으로 borderRadius 설정
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.exerciseType,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '무게: ${widget.set.weight} kg  횟수: ${widget.set.reps} 회',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                Text(
                  widget.set.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
