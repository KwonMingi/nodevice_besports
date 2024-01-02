import 'package:nodevice/data_struct/user.dart';
import 'package:nodevice/io/firebase_service.dart';

class BoolStatus {
  static bool isModal = false;
  static bool isModalOpen = false;
}

class UID {
  static String uid = "";
}

class ExerciseStatus {
  static UserData user = UserData();

  static Future<void> loadUserData(String userID) async {
    FirestoreService firestoreService = FirestoreService();
    user = await firestoreService.getUserData(userID);
  }
}
