import 'package:nodevice/constants/static_status.dart';
import 'package:nodevice/data_struct/exercise_data.dart';

class HistoryViewModel {
  final String date;
  List<Exercise> exercisesOnDate = [];

  HistoryViewModel({required this.date});

  void loadExercises() {
    exercisesOnDate = ExerciseStatus.user.findExercisesByDate(date);
  }

  double getVolume(Exercise exercise) {
    return ExerciseStatus.user
            .getExerciseByTypeTotalVolum(exercise.exerciseType, date) ??
        0.0;
  }

  double getMaxOneRM(Exercise exercise) {
    return ExerciseStatus.user.getMaxOneRM(exercise.exerciseType, date) ?? 0.0;
  }

  Future<void> refreshExercises() async {
    loadExercises();
    // You can also handle any other logic needed during refresh here
  }

  // 다른 비즈니스 로직들...
}
