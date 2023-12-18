import 'package:intl/intl.dart';

class SetData {
  late final double _weight;
  late final int _reps;
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
}
