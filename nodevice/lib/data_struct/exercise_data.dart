import 'package:intl/intl.dart';
import 'package:nodevice/dataStruct/setData.dart';

class Exercise {
  late String _date;
  late final String _exerciseType;
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

  String get date => _date;
  String get exerciseType => _exerciseType;
  List<SetData> get setDatas => _setDatas;
}
