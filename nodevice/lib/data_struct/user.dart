import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/io/uuid_io.dart';

class UserData {
  late String _uuid;
  late List<Exercise> _exercises;

  UserData() {
    initUUID();
    _exercises = [];
  }
  void initUUID() async {
    String uuid = await getOrCreateUuid();
    _uuid = uuid;
  }

  String get userID => _uuid;
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
