import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nodevice/data_struct/set_data.dart';
part 'exercise_data.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  late String _date;
  @HiveField(1)
  late final String _exerciseType;
  @HiveField(2)
  late List<SetData> _setDatas;

  Exercise(String exerciseType) : _exerciseType = exerciseType {
    dateInit();
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
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    Exercise exercise = Exercise(map['exerciseType']);
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
}
