import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/io/firebase_service.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late String _uuid;
  @HiveField(1)
  late List<Exercise> _exercises;

  UserData() {
    initUUID();
    _exercises = [];
  }
  void initUUID() {
    String? userId = getCurrentUserId();
    _uuid = userId!;
  }

  String get userID => _uuid;
  set setUserID(String id) => _uuid = id;
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

  Map<String, dynamic> toMap() {
    return {
      'uuid': _uuid,
      'exercises': _exercises.map((e) => e.toMap()).toList(),
    };
  }

  static UserData fromMap(Map<String, dynamic> map) {
    UserData userData = UserData();
    userData._uuid = map['uuid'];
    if (map['exercises'] != null) {
      userData._exercises =
          map['exercises'].map<Exercise>((e) => Exercise.fromMap(e)).toList();
    }
    return userData;
  }
}
