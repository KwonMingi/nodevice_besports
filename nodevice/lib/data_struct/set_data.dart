import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'set_data.g.dart';

@HiveType(typeId: 2)
class SetData extends HiveObject {
  @HiveField(0)
  late final double _weight;
  @HiveField(1)
  late final int _reps;
  @HiveField(2)
  late String _time;

  SetData(double weight, int reps)
      : _weight = weight,
        _reps = reps {
    timeInit();
  }
  void timeInit() {
    _time = DateFormat('HH:mm:ss').format(DateTime.now());
  }

  double get weight => _weight;
  int get reps => _reps;
  String get time => _time;

  void updateSetData(double weight, int reps) {
    _weight = weight;
    _reps = reps;
    timeInit(); // 시간 업데이트
  }

  void resetData() {
    _weight = 0;
    _reps = 0;
    _time = '';
  }

  Map<String, dynamic> toMap() {
    return {
      'weight': _weight,
      'reps': _reps,
      'time': _time,
    };
  }

  static SetData fromMap(Map<String, dynamic> map) {
    SetData setData = SetData(map['weight'], map['reps']);
    setData._time = map['time'];
    return setData;
  }
}
