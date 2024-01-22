import 'dart:developer';

import 'package:nodevice/io/firebase_data_service.dart';

class UserProfile {
  late String? _uid = getCurrentUserId();
  late String firstName;
  late String lastName;
  late int age;
  late String birthday;
  late bool recordSharingPermissionAllowed;
  late final String centerID;
  late String ptTrainerID;
  late final String nickName;
  late final String tag;

  UserProfile({
    required this.birthday,
    required this.firstName,
    required this.lastName,
    required this.recordSharingPermissionAllowed,
    required this.centerID,
    required this.nickName,
    required this.tag,
    required this.ptTrainerID,
  }) {
    initAge();
  }

  void initAge() {
    DateTime birthDate = DateTime.parse(birthday);
    DateTime currentDate = DateTime.now();
    int tempAge = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      tempAge--;
    }
    age = tempAge;
  }

  String? get uid => _uid;
}
