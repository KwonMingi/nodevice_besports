class ExerciseModelFromJson {
  List<List<int>> totalExerciseSet;
  DateTime exerciseTime;

  ExerciseModelFromJson({
    required this.totalExerciseSet,
    required this.exerciseTime,
  });

// json파일에서 set수를 정확히 알수가 없으므로 이에대해 수정이 필요함.
  ExerciseModelFromJson.fromJson(Map<String, dynamic> json)
      : totalExerciseSet = json["set"],
        exerciseTime = json["exerciseTime"];
}
