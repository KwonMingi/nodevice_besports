class ExerciseProfile {
  late double stature;
  late double weight;
  late double bodyPerFat;
  late double skeletalMuscle;
  late String benchOneRM;
  late String squrtOneRM;
  late String deadliftOneRM;
  late double averageExerciseIntensity;

  ExerciseProfile(
      {required this.stature,
      required this.weight,
      required this.bodyPerFat,
      required this.skeletalMuscle,
      required this.benchOneRM,
      required this.deadliftOneRM,
      required this.squrtOneRM,
      required this.averageExerciseIntensity});

  Map<String, dynamic> toMap() {
    return {
      'stature': stature,
      'weight': weight,
      'bodyPerFat': bodyPerFat,
      'skeletalMuscle': skeletalMuscle,
      'benchOneRM': benchOneRM,
      'deadliftOneRM': deadliftOneRM,
      'squrtOneRM': squrtOneRM,
      'averageExerciseIntensity': averageExerciseIntensity
    };
  }

  factory ExerciseProfile.fromMap(Map<String, dynamic> map) {
    return ExerciseProfile(
        stature: map['stature'],
        weight: map['weight'],
        bodyPerFat: map['bodyPerFat'],
        skeletalMuscle: map['skeletalMuscle'],
        benchOneRM: map['benchOneRM'],
        deadliftOneRM: map['deadliftOneRM'],
        squrtOneRM: map['squrtOneRM'],
        averageExerciseIntensity: map['averageExerciseIntensity']);
  }
}
