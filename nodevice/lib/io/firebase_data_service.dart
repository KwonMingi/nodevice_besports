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

class FirestoreDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadUserData(UserData userData) async {
    var userDocRef = _db.collection('users').doc(userData.userID);
    var userDoc = await userDocRef.get();

    if (userDoc.exists) {
      await _updateExercises(userDocRef, userData.exercises);
    } else {
      var dataMap = userData.toMap();
      await userDocRef.set(dataMap);
    }
  }

  Future<void> _updateExercises(
      DocumentReference userDocRef, List<Exercise> exercises) async {
    var exerciseCollectionRef = userDocRef.collection('exercises');

    for (var exercise in exercises) {
      String exerciseDocId = '${exercise.exerciseType}_${exercise.date}';
      var exerciseDocRef = exerciseCollectionRef.doc(exerciseDocId);
      var exerciseDoc = await exerciseDocRef.get();

      if (!exerciseDoc.exists) {
        var exerciseDataMap = exercise.toMap(); // restTime 포함
        // setDatas 배열을 저장하지 않고, 대신 각 SetData를 별도의 문서로 저장합니다.
        exerciseDataMap.remove('setDatas');
        await exerciseDocRef.set(exerciseDataMap);
      }
      await _updateSetData(exerciseDocRef, exercise.setDatas);
    }
  }

  Future<void> _updateSetData(
      DocumentReference exerciseDocRef, List<SetData> setDatas) async {
    var setDataCollectionRef = exerciseDocRef.collection('setData');

    for (var setData in setDatas) {
      String setDataDocId = setData.time; // 'time'을 문서 ID로 사용
      var setDataDocRef = setDataCollectionRef.doc(setDataDocId);
      var setDataMap = setData.toMap();
      await setDataDocRef.set(setDataMap); // 각 SetData를 별도의 문서로 저장
    }
  }

  Future<void> updateSetData(String userID, String date, String exerciseType,
      String setTime, Map<String, dynamic> newData) async {
    // Exercise 문서의 참조를 찾습니다.
    var exerciseDocRef = _db
        .collection('users')
        .doc(userID)
        .collection('exercises')
        .doc('${exerciseType}_$date');

    // 해당 Exercise 문서 내부의 SetData 컬렉션 참조를 가져옵니다.
    var setDataCollectionRef = exerciseDocRef.collection('setData');

    // SetData 문서 참조를 가져옵니다.
    var setDataDocRef = setDataCollectionRef.doc(setTime); // 'time'을 문서 ID로 사용

    // SetData 문서를 업데이트하거나 새로운 문서를 추가합니다.
    await setDataDocRef.set(newData, SetOptions(merge: true));
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
      Exercise exercise = Exercise.fromMap(
          exerciseMap); // This method now properly initializes _restTime
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
      exercise.addSetData(setData); // 여기서 SetData 객체를 추가합니다.
    }
  }
}
