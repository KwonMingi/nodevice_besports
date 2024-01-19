import 'package:nodevice/constants/static_status.dart';

String createChatRoomId(String userId2) {
  String uid = ExerciseStatus.user.userID;
  return uid.compareTo(userId2) > 0 ? '${uid}_$userId2' : '${userId2}_$uid';
}
