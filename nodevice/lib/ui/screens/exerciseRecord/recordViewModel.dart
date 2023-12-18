import 'package:intl/intl.dart';
import 'package:nodevice/constants/staticStatus.dart';
import 'package:nodevice/dataStruct/user.dart';
import 'package:nodevice/dataStruct/instance.dart';

class RecordViewModel {
  int _currentSet = 0;
  final int _setCount;
  final String _exerciseType;
  late final String _UID;

  int get currentSet => _currentSet;
  int get setCount => _setCount;
  late UserData user;
  late Exercise exercise;
  String get exerciseType => _exerciseType;
  late final String nowDate;

  RecordViewModel(
      {required int setCount,
      required String exerciseType,
      required String uid})
      : _exerciseType = exerciseType,
        _setCount = setCount,
        _UID = uid {
    nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    user = UserData(_UID);
    exercise = Exercise(_exerciseType);
  }

  void saveSetData(String weight, String reps) {
    double parsedWeight = double.tryParse(weight) ?? 0;
    int parsedReps = int.tryParse(reps) ?? 0;

    SetData setData = SetData(parsedWeight, parsedReps);
    exercise.addSetData(setData);
    _currentSet++;

    // 모든 세트를 완료했을 때 ExerciseStatus.user에 운동 데이터 추가
    if (_currentSet == _setCount) {
      // 현재 운동을 ExerciseStatus.user에 추가
      ExerciseStatus.user.addExercise(exercise);
    }
  }
}
