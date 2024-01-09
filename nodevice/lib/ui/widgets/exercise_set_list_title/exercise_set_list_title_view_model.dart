import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nodevice/constants/static_status.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/io/firebase_data_service.dart';

class ExerciseSetViewModel {
  final FirestoreDataService firestoreService = FirestoreDataService();

  final TextEditingController _weightController;
  final TextEditingController _repsController;

  ExerciseSetViewModel(
      {required TextEditingController weightController,
      required TextEditingController repsController})
      : _repsController = repsController,
        _weightController = weightController;

  Future<void> updateSetData(String userID, String date, String exerciseType,
      String setTime, Map<String, dynamic> updatedData) async {
    await firestoreService.updateSetData(
        userID, date, exerciseType, setTime, updatedData);
    // Additional business logic can be added here if needed
  }

  Future<void> updateSetDataInUser(String userID, String date,
      String exerciseType, String setTime, SetData updatedData) async {
    // 해당하는 Exercise 찾기
    Exercise? targetExercise = ExerciseStatus.user.exercises.firstWhereOrNull(
        (ex) => ex.exerciseType == exerciseType && ex.date == date);

    // 해당하는 SetData 찾기
    SetData? targetSetData =
        targetExercise?.setDatas.firstWhereOrNull((sd) => sd.time == setTime);

    // SetData 업데이트
    targetSetData?.setWeight = updatedData.weight;
    targetSetData?.setReps = updatedData.reps;
    // 추가적인 필드가 있다면 여기에 업데이트

    // 변경 사항 Firestore에 저장
    await ExerciseStatus.saveUserData();
  }

  TextEditingController get weightController => _weightController;
  TextEditingController get repsController => _repsController;
  set setWeightController(String weight) => _weightController.text = weight;
  set setRepsController(String reps) => _repsController.text = reps;
}
