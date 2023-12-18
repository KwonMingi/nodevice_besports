import 'package:intl/intl.dart';

class UserData {
  late String _userID;
  late List<Exercise> _exercises;

  UserData(String userID) {
    _userID = userID;
    _exercises = [];
  }

  String get userID => _userID;
  List<Exercise> get exercises => _exercises;

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
  }

  List<Exercise> findExercisesByType(String type) {
    return _exercises
        .where((exercise) => exercise.exerciseType == type)
        .toList();
  }

  List<Exercise> findExercisesByDate(String date) {
    return _exercises.where((exercise) => exercise.date == date).toList();
  }

  Map<String, dynamic> calculateTotalStats() {
    int totalSets = 0;
    double totalWeight = 0;
    int totalReps = 0;

    for (var exercise in _exercises) {
      for (var setData in exercise.setDatas) {
        totalSets++;
        totalWeight += setData.weight;
        totalReps += setData.reps;
      }
    }

    return {
      'totalSets': totalSets,
      'totalWeight': totalWeight,
      'totalReps': totalReps
    };
  }
}

class Exercise {
  late String _date;
  late final String _exerciseType;
  late List<SetData> _setDatas;

  Exercise(String exerciseType) : _exerciseType = exerciseType {
    dateInit();
    _setDatas = [];
  }

  void dateInit() {
    _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void addSetData(SetData setData) {
    _setDatas.add(setData);
  }

  String get date => _date;
  String get exerciseType => _exerciseType;
  List<SetData> get setDatas => _setDatas;
}

class SetData {
  late final double _weight;
  late final int _reps;
  late String _time;

  SetData(double weight, int reps)
      : _weight = weight,
        _reps = reps {
    timeInit();
  }
  void timeInit() {
    _time = DateFormat('HH:mm:ss').format(DateTime.now());
  }

  double get weight => _weight;
  int get reps => _reps;
  String get time => _time;

  void updateSetData(double weight, int reps) {
    _weight = weight;
    _reps = reps;
    timeInit(); // 시간 업데이트
  }

  void resetData() {
    _weight = 0;
    _reps = 0;
    _time = '';
  }
}
