class ExerciseModel {
  final List<int> exerciseSet; // {weight, reps}
  DateTime exerciseTime;

  ExerciseModel({
    required this.exerciseSet,
    required this.exerciseTime,
  });

  Map<String, dynamic> toJson(int currentSet) {
    return {
      "$currentSet set": exerciseSet,
      "exerciseTime": exerciseTime.microsecondsSinceEpoch,
    };
  }

  ExerciseModel.fromJson(Map<String, dynamic> json)
      : exerciseSet = json["currentSet set"],
        exerciseTime = json["exerciseTime"];
}
