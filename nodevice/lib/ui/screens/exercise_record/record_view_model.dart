import 'package:intl/intl.dart';
import 'package:nodevice/constants/static_status.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/user.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/io/firebase_service.dart';

class RecordViewModel {
  int _currentSet = 0;
  final int _setCount;
  final String _exerciseType;

  int get currentSet => _currentSet;
  int get setCount => _setCount;
  late UserData _user;
  late Exercise exercise;
  String get exerciseType => _exerciseType;
  late final String nowDate;

  UserData get user => _user;

  RecordViewModel(
      {required int setCount,
      required String exerciseType,
      required String uid})
      : _exerciseType = exerciseType,
        _setCount = setCount {
    nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _user = UserData();
    exercise = Exercise(_exerciseType);
  }

  void saveSetData(String weight, String reps) async {
    double parsedWeight = double.tryParse(weight) ?? 0;
    int parsedReps = int.tryParse(reps) ?? 0;

    SetData setData = SetData(parsedWeight, parsedReps);
    exercise.addSetData(setData);
    _currentSet++;

    // 모든 세트를 완료했을 때 ExerciseStatus.user에 운동 데이터 추가
    if (_currentSet == _setCount) {
      // 현재 운동을 ExerciseStatus.user에 추가
      _user.addExercise(exercise);
      await uploadUserDataToFirestore();
    }
  }

  Future<void> uploadUserDataToFirestore() async {
    // 현재 로그인한 사용자의 UID 가져오기
    String? userID = getCurrentUserId();
    if (userID != null) {
      // UserID 설정
      _user.setUserID = userID;

      // FirestoreService 인스턴스 생성
      FirestoreService firestoreService = FirestoreService();

      // UserData 업로드
      await firestoreService.uploadUserData(_user);
    } else {
      // 사용자가 로그인하지 않았을 경우의 처리
      print("No user is currently logged in.");
    }
  }
}
