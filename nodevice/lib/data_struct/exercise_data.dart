import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nodevice/data_struct/set_data.dart';
part 'flutter_data_g_file/exercise_data.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  late String _date;
  @HiveField(1)
  late String _exerciseType;
  @HiveField(2)
  late List<SetData> _setDatas;
  @HiveField(3)
  late int _restTime;

  Exercise(String exerciseType, restTime) : _exerciseType = exerciseType {
    dateInit();
    _restTime = restTime;
    _setDatas = [];
  }

  void dateInit() {
    _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void addSetData(SetData setData) {
    _setDatas.add(setData);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': _date,
      'exerciseType': _exerciseType,
      'setDatas': _setDatas.map((s) => s.toMap()).toList(),
      'restTime': _restTime, // Add this line
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    int restTime = map['restTime'] ?? 0; // Default to 0 if not present
    Exercise exercise = Exercise(map['exerciseType'], restTime);
    exercise._date = map['date'];

    if (map['setDatas'] != null) {
      exercise._setDatas =
          map['setDatas'].map<SetData>((s) => SetData.fromMap(s)).toList();
    }
    return exercise;
  }

  String get date => _date;
  String get exerciseType => _exerciseType;
  List<SetData> get setDatas => _setDatas;
  set setExerceiseType(String ex) => _exerciseType = ex;
  set setRestTime(int restTime) => _restTime = restTime;
}
