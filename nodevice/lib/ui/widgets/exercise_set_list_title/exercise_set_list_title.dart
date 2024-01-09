import 'package:flutter/material.dart';
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
  const ExerciseSetListTile({
    Key? key,
    required this.setNum,
    required this.set,
    required this.userID,
    required this.date,
    required this.exerciseType,
    required this.onUpdate,
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
    return ListTile(
      title: Text(
        '세트 ${widget.setNum}',
        style: const TextStyle(color: Color(0xFF9F7BFF)),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('무게: ${widget.set.weight} kg'),
          const SizedBox(width: 15),
          Text('횟수: ${widget.set.reps} 회'),
          const Spacer(),
          Text(
            widget.set.time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onTap: () => _showEditDialog(context),
    );
  }
}
