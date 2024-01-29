import 'package:hive/hive.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/utils/exercise_calculate.dart';
part 'flutter_data_g_file/user.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late String _uid;
  @HiveField(1)
  late List<Exercise> _exercises;
  @HiveField(2)
  UserData() {
    initUID();
    _exercises = [];
  }
  void initUID() {
    String? userId = getCurrentUserId();
    _uid = userId!;
  }

  String get userID => _uid;
  set setUserID(String id) => _uid = id;
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
      'uuid': _uid,
      'exercises': _exercises.map((e) => e.toMap()).toList(),
    };
  }

  static UserData fromMap(Map<String, dynamic> map) {
    UserData userData = UserData();
    // 'uuid'가 null이면 빈 문자열을 할당합니다.
    userData._uid = map['uuid'] ?? '';

    // 'exercises' 필드가 null이 아닌 경우에만 처리합니다.
    if (map['exercises'] != null) {
      userData._exercises = map['exercises']
          .map<Exercise>((e) => Exercise.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    return userData;
  }

  List<Exercise> findExercisesByTypeAndDate(String exerciseType, String date) {
    return _exercises
        .where((exercise) =>
            exercise.exerciseType == exerciseType && exercise.date == date)
        .toList();
  }

  double? getExerciseByTypeTotalVolum(String exerciseType, String date) {
    double totalVolume = 0;
    List<Exercise> exercises = findExercisesByTypeAndDate(exerciseType, date);
    for (Exercise e in exercises) {
      for (SetData setData in e.setDatas) {
        totalVolume += setData.reps * setData.weight;
      }
    }
    return totalVolume;
  }

  double calculateTotalVolume(String date) {
    double totalVolume = 0;

    for (var exercise in _exercises) {
      if (exercise.date == date) {
        for (var setData in exercise.setDatas) {
          totalVolume += setData.weight * setData.reps;
        }
      }
    }

    return totalVolume;
  }

  double? getMaxOneRM(String exerciseType, String date) {
    List<Exercise> exercises = findExercisesByTypeAndDate(exerciseType, date);
    double maxOneRM = 0.0;
    for (Exercise e in exercises) {
      for (SetData setData in e.setDatas) {
        double currentOneRM = getOneRM(setData);
        if (currentOneRM > maxOneRM) {
          maxOneRM = currentOneRM; // 최댓값 갱신
        }
      }
    }
    return maxOneRM > 0.0 ? maxOneRM : null; // maxOneRM이 0보다 크면 반환, 아니면 null 반환
  }

  bool updateSetDataValues(String exerciseType, String date, String time,
      double newWeight, int newReps) {
    for (var exercise in _exercises) {
      // 주어진 exerciseType과 date에 맞는 운동을 찾습니다.
      if (exercise.exerciseType == exerciseType && exercise.date == date) {
        for (var setData in exercise.setDatas) {
          // 주어진 time에 해당하는 setData를 찾습니다.
          if (setData.time == time) {
            // weight와 reps 값을 새로운 값으로 업데이트합니다.
            setData.setWeight = newWeight;
            setData.setReps = newReps;
            return true; // 업데이트 성공
          }
        }
      }
    }
    return false; // 해당하는 SetData를 찾지 못한 경우
  }
}
