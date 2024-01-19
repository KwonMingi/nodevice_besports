import 'package:nodevice/constants/static_status.dart';
import 'package:nodevice/io/firebase_data_service.dart';

class UserProfile {
  late String _uid;
  late String _firstName;
  late String _lastName;
  late int _age;
  late String _birthday;
  late bool _recordSharingPermissionAllowed;
  late final String _centerID;
  late String _ptTrainerID;
  late final String _nickName;
  late final String _tag;

  UserProfile({
    required birthday,
    required firstName,
    required lastName,
    required permission,
    required centerID,
    required nickName,
    required tag,
    required pt,
  })  : _birthday = birthday,
        _firstName = firstName,
        _lastName = lastName,
        _recordSharingPermissionAllowed = permission,
        _centerID = centerID,
        _ptTrainerID = pt,
        _nickName = nickName,
        _tag = tag {
    initUID();
    initAge();
  }
  void initUID() {
    _uid = ExerciseStatus.user.userID;
  }

  void initAge() {
    DateTime birthDate = DateTime.parse(_birthday);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    _age = age;
  }

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get birthday => _birthday;
  int get age => _age;
  bool get permission => _recordSharingPermissionAllowed;
  String get centerUID => _centerID;
  String get ptUID => _ptTrainerID;
  String get uid => _uid;
  String get nickName => _nickName;
  String get tag => _tag;
  set setPtUID(String pt) => _ptTrainerID = pt;
  set setPermission(bool permission) =>
      _recordSharingPermissionAllowed = permission;
  set setFirstName(String firstName) => _firstName = firstName;
  set setLastName(String lastName) => _lastName = lastName;
  set setAge(int age) => _age = age;
  set setBirthday(String birthday) => _birthday = birthday;
}
