import 'package:nodevice/io/firebase_data_service.dart';

class UserProfile {
  late String _uid;
  late String _firstName;
  late String _lastName;
  late int _age;
  late String _birthday;
  late bool _recordSharingPermissionAllowed;
  late String _centerUID;
  late String _ptTrainerUID;

  UserProfile(
      {required birthday,
      required firstName,
      required lastName,
      required permission})
      : _birthday = birthday,
        _firstName = firstName,
        _lastName = lastName,
        _recordSharingPermissionAllowed = permission {
    initUID();
    initAge();
  }
  void initUID() {
    _uid = getCurrentUserId()!;
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
  String get senterUID => _centerUID;
  String get ptUID => _ptTrainerUID;
  String get uid => _uid;
  set setPtUID(String pt) => _ptTrainerUID = pt;
  set setPermission(bool permission) =>
      _recordSharingPermissionAllowed = permission;
  set setFirstName(String firstName) => _firstName = firstName;
  set setLastName(String lastName) => _lastName = lastName;
  set setAge(int age) => _age = age;
  set setBirthday(String birthday) => _birthday = birthday;
}
