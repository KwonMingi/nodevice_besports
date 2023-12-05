import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodevice/exercise/exerciseModel/exerciseModel.dart';
import 'package:nodevice/exercise/exerciseModel/exerciseModelFromJson.dart';

class ExerciseRepo {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late ExerciseModel exerciseModel; // temp

  ExerciseRepo();

  Future<DocumentSnapshot<Map<String, dynamic>>> getExerciseSet(
      String exerciseType) async {
    late final DocumentSnapshot<Map<String, dynamic>> temp;
    temp = await db
        .collection("users")
        .doc("asdasdasd")
        .collection("exercise")
        .doc(exerciseType)
        .get();
    return temp;
  }

  // viewModel method
  Future<ExerciseModelFromJson> getExerciseSet2() async {
    final snapshotSet = await getExerciseSet("rowrow"); // exerciseType 받아야함
    final sets = snapshotSet.data();
    return ExerciseModelFromJson.fromJson(sets!);
  }

  Future<void> sendExerciseSet(
      String exerciseType, int currentSet, List<int> set) async {
    exerciseModel =
        ExerciseModel(exerciseSet: set, exerciseTime: DateTime.now());
    await db
        .collection("users")
        .doc("asdasdasd")
        .collection("exercise")
        .doc(exerciseType)
        .update(exerciseModel.toJson(currentSet));
  }
}
