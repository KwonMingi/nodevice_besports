import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodevice/data_struct/exercise_profile.dart';
import 'package:nodevice/io/firebase_data_service.dart';

class ExerciseProfileFirebaseManager {
  late ExerciseProfile profile;
  String? uid = getCurrentUserId();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 새로운 ExerciseProfile 업로드
  Future<void> uploadExerciseProfile(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'exercise_profile': profile.toMap()});
    } catch (e) {
      print('Error uploading exercise profile: $e');
      // 오류 처리 로직
    }
  }

  // 기존 ExerciseProfile 업데이트
  Future<void> updateExerciseProfile(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'exercise_profile': profile.toMap()});
    } catch (e) {
      print('Error updating exercise profile: $e');
      // 오류 처리 로직
    }
  }

  Future<ExerciseProfile?> getExerciseProfile(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('exercise_profile')) {
          return ExerciseProfile.fromMap(data['exercise_profile']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching exercise profile: $e');
      // 오류 처리 로직
      return null;
    }
  }
}
