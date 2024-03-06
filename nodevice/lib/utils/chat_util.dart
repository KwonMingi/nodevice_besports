import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

Future<types.Room?> getRoomWithId(String chatRoomId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot roomDoc =
        await firestore.collection('rooms').doc(chatRoomId).get();

    if (roomDoc.exists) {
      Map<String, dynamic>? roomData = roomDoc.data() as Map<String, dynamic>?;

      if (roomData != null) {
        List<dynamic> userIds = roomData['userIds'] ?? [];
        List<types.User> users =
            userIds.map((userId) => types.User(id: userId.toString())).toList();

        // 채팅방 이름이 null인 경우 'Unnamed Room'을 사용합니다.
        String roomName = roomData['name'] ?? 'Unnamed Room';

        // 채팅방 유형을 정확히 처리합니다. 'direct'인 경우 types.RoomType.direct를 사용합니다.
        types.RoomType roomType = roomData['type'] == 'direct'
            ? types.RoomType.direct
            : types.RoomType.group;

        types.Room room = types.Room(
          id: roomDoc.id,
          name: roomName, // 채팅방 이름 설정
          type: roomType, // 채팅방 유형 설정
          users: users, // 채팅방 사용자 리스트 설정
        );

        return room;
      } else {
        print('Room data is null for ID $chatRoomId');
        return null;
      }
    } else {
      print('Room with ID $chatRoomId not found');
      return null;
    }
  } catch (e) {
    print('Error fetching room: $e');
    return null;
  }
}
