import 'package:hive/hive.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/data_struct/user.dart';

class DataManager {
  // 박스 이름을 상수로 정의
  late final String userBoxName;
  late final String exerciseBoxName;
  late final String setDataBoxName;

  DataManager(String uid) {
    userBoxName = 'userBox_$uid';
    exerciseBoxName = 'exerciseBox_$uid';
    setDataBoxName = 'setData_$uid';
  }

  // UserData 저장
  Future<void> saveUserData(UserData userData) async {
    var box = await Hive.openBox<UserData>(userBoxName);
    await box.put('userData', userData);
    await box.close();
  }

  // UserData 불러오기
  Future<UserData?> getUserData() async {
    var box = await Hive.openBox<UserData>(userBoxName);
    UserData? userData = box.get('userData');
    await box.close();
    return userData;
  }

  // Exercise 데이터 저장
  Future<void> saveExercise(Exercise exercise) async {
    var box = await Hive.openBox<Exercise>(exerciseBoxName);
    await box.add(exercise);
    await box.close();
  }

  // Exercise 데이터 리스트 불러오기
  Future<List<Exercise>> getExercises() async {
    var box = await Hive.openBox<Exercise>(exerciseBoxName);
    List<Exercise> exercises = box.values.toList();
    await box.close();
    return exercises;
  }

  // SetData 데이터 저장
  Future<void> saveSetData(SetData setData) async {
    var box = await Hive.openBox<SetData>(setDataBoxName);
    await box.add(setData);
    await box.close();
  }

  // SetData 데이터 리스트 불러오기
  Future<List<SetData>> getSetDatas() async {
    var box = await Hive.openBox<SetData>(setDataBoxName);
    List<SetData> setDatas = box.values.toList();
    await box.close();
    return setDatas;
  }
}
