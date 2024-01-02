import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/data_struct/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

String? getCurrentUserId() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  return user?.uid; // 현재 로그인한 사용자의 UID를 반환합니다.
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadUserData(UserData userData) async {
    var userDocRef = _db.collection('users').doc(userData.userID);
    var userDoc = await userDocRef.get();

    if (userDoc.exists) {
      // 이미 존재하는 사용자에 대한 데이터 추가/업데이트 로직
      await _updateExercises(userDocRef, userData.exercises);
    } else {
      // 새 사용자 데이터 업로드
      var dataMap = userData.toMap();
      await userDocRef.set(dataMap);
    }
  }

  Future<void> _updateExercises(
      DocumentReference userDocRef, List<Exercise> exercises) async {
    var exerciseCollectionRef = userDocRef.collection('exercises');

    for (var exercise in exercises) {
      // exerciseType과 date를 조합하여 고유한 ID 생성
      String exerciseDocId = '${exercise.exerciseType}_${exercise.date}';
      var exerciseDocRef = exerciseCollectionRef.doc(exerciseDocId);
      var exerciseDoc = await exerciseDocRef.get();

      if (!exerciseDoc.exists) {
        var exerciseDataMap = exercise.toMap();
        await exerciseDocRef.set(exerciseDataMap);
      } else {
        // 이미 존재하는 운동에 대한 SetData 추가/업데이트 로직
        await _updateSetData(exerciseDocRef, exercise.setDatas);
      }
    }
  }

  Future<void> _updateSetData(
      DocumentReference exerciseDocRef, List<SetData> setDatas) async {
    var setDataCollectionRef = exerciseDocRef.collection('setData');

    for (var setData in setDatas) {
      var setDataDocRef = setDataCollectionRef.doc(setData.time);
      var setDataDoc = await setDataDocRef.get();

      if (!setDataDoc.exists) {
        var setDataMap = setData.toMap();
        await setDataDocRef.set(setDataMap);
      }
    }
  }

  Future<void> updateSetData(String userID, String date, String exerciseType,
      String setTime, Map<String, dynamic> newData) async {
    // Exercise 문서의 참조를 찾습니다.
    var exerciseDocRef = _db
        .collection('users')
        .doc(userID)
        .collection('exercises')
        .doc('${date}_$exerciseType');

    // 해당 Exercise 문서 내부의 SetData 컬렉션 참조를 가져옵니다.
    var setDataCollectionRef = exerciseDocRef.collection('setData');

    // SetData 문서 참조를 가져옵니다.
    var setDataDocRef = setDataCollectionRef.doc(setTime);
    var setDataDoc = await setDataDocRef.get();

    if (setDataDoc.exists) {
      // 해당 시간에 대한 SetData가 존재하면 업데이트 합니다.
      await setDataDocRef.update(newData);
    } else {
      // 존재하지 않는다면 새로운 SetData를 추가합니다.
      await setDataDocRef.set(newData);
    }
  }

  Future<UserData> getUserData(String userID) async {
    var userDocRef = _db.collection('users').doc(userID);
    var userDoc = await userDocRef.get();

    if (userDoc.exists) {
      // UserData 문서를 Map으로 변환
      var userDataMap = userDoc.data() as Map<String, dynamic>;
      // UserData 객체로 변환
      UserData userData = UserData.fromMap(userDataMap);

      // Exercise 데이터를 불러오는 부분
      await _loadExercises(userDocRef, userData);

      return userData;
    } else {
      // 새 UserData 객체 생성
      UserData userData = UserData();
      userData.setUserID = userID; // userID 설정

      // Firestore에 새 사용자 문서 저장
      await uploadUserData(userData);

      return userData;
    }
  }

  Future<void> _loadExercises(
      DocumentReference userDocRef, UserData userData) async {
    var exerciseCollectionRef = userDocRef.collection('exercises');
    var exerciseSnapshot = await exerciseCollectionRef.get();

    for (var exerciseDoc in exerciseSnapshot.docs) {
      var exerciseMap = exerciseDoc.data();
      Exercise exercise = Exercise.fromMap(exerciseMap);

      // SetData 데이터를 불러오는 부분
      await _loadSetData(exerciseDoc.reference, exercise);

      userData.addExercise(exercise);
    }
  }

  Future<void> _loadSetData(
      DocumentReference exerciseDocRef, Exercise exercise) async {
    var setDataCollectionRef = exerciseDocRef.collection('setData');
    var setDataSnapshot = await setDataCollectionRef.get();

    for (var setDataDoc in setDataSnapshot.docs) {
      var setDataMap = setDataDoc.data();
      SetData setData = SetData.fromMap(setDataMap);
      exercise.addSetData(setData);
    }
  }
}
