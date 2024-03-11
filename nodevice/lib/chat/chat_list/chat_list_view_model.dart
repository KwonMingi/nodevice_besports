import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:intl/intl.dart';
import 'package:nodevice/data_struct/firebase_data_manages/user_firebase_manager.dart';

class ChatRoomsViewModel extends ChangeNotifier {
  final List<types.Room> _chatRooms = [];
  final String currentUserId; // 현재 사용자 ID

  final UserService _userService = UserService();

  ChatRoomsViewModel(this.currentUserId) {
    // 생성자를 통해 현재 사용자 ID를 받음
    _loadChatRooms();
  }

  List<types.Room> get chatRooms => _chatRooms;

  Future<void> _loadChatRooms() async {
    FirebaseChatCore.instance.rooms().listen((List<types.Room> rooms) {
      final filteredRooms = rooms.where((room) {
        return room.users
            .any((user) => user.id == currentUserId); // 현재 사용자가 속한 채팅방만 필터링
      }).toList();

      _chatRooms.clear();
      _chatRooms.addAll(filteredRooms); // 필터링된 채팅방 목록을 _chatRooms에 추가
      notifyListeners(); // 채팅방 목록이 변경되었음을 알림
    });
  }

  Future<String?> getOtherParticipantFirstName(types.Room room) async {
    try {
      // 나를 제외한 첫 번째 다른 참가자를 찾습니다.
      final otherUser =
          room.users.firstWhere((user) => user.id != currentUserId);

      // 다른 참가자가 있으면 그의 first_name을 가져옵니다.
      return await _userService.getUserFirstName(otherUser.id);
    } catch (e) {
      print(e); // 에러 로깅
      return 'unkwon'; // 에러 발생 시 기본값 반환
    }
  }

  Future<String> getLatestMessageText(types.Room room) async {
    final roomId = room.id;
    try {
      // 해당 채팅방의 가장 최근 메시지를 조회합니다.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms/$roomId/messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      final docs = querySnapshot.docs;
      if (docs.isNotEmpty) {
        // 최근 메시지의 텍스트를 반환합니다.
        return docs.first.get('text') ?? "No messages";
      }
      return "No messages"; // 메시지가 없는 경우
    } catch (e) {
      print("Error getting latest message: $e");
      return "Error loading message"; // 오류가 발생한 경우
    }
  }

  String formatLastMessageTime(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final format = now.difference(date).inDays < 1
        ? 'a h:mm'
        : 'MMM d'; // 오늘 메시지면 시간, 아니면 날짜
    return DateFormat(format).format(date);
  }

  Future<int> getUnreadMessagesCount(types.Room room) async {
    final String currentUserId = this.currentUserId; // 현재 사용자 ID
    final roomId = room.id; // 채팅방 ID

    try {
      // 사용자가 채팅방에 마지막으로 접속한 시간을 가져옵니다. 이는 예시이며, 실제 구현은 데이터 구조에 따라 달라질 수 있습니다.
      final userLastSeenTime = await FirebaseFirestore.instance
          .collection('users_profile')
          .doc(currentUserId)
          .get()
          .then((doc) => doc.data()?['lastSeenTime'] ?? Timestamp.now());

      // 사용자가 마지막으로 접속한 이후의 새로운 메시지를 조회합니다.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms/$roomId/messages')
          .where('createdAt', isGreaterThan: userLastSeenTime)
          .get();

      // 조회된 메시지 중에서 사용자가 읽지 않은 메시지의 수를 계산합니다.
      int unreadMessagesCount = 0;
      for (var message in querySnapshot.docs) {
        List readByUsers = message.data()['readByUsers'] ?? [];
        if (!readByUsers.contains(currentUserId)) {
          unreadMessagesCount++;
        }
      }

      return unreadMessagesCount;
    } catch (e) {
      print("Error getting unread messages count: $e");
      return 0; // 오류 발생 시 0을 반환
    }
  }

  Future<Timestamp> getLatestMessageTimestamp(types.Room room) async {
    final roomId = room.id;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms/$roomId/messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      final docs = querySnapshot.docs;
      if (docs.isNotEmpty) {
        // 최근 메시지의 생성 시간(Timestamp)을 반환합니다.
        return docs.first.get('createdAt') as Timestamp;
      } else {
        // 메시지가 없는 경우 현재 시간을 반환합니다.
        return Timestamp.fromDate(DateTime.now());
      }
    } catch (e) {
      print("Error getting latest message timestamp: $e");
      // 오류가 발생한 경우 현재 시간을 반환합니다.
      return Timestamp.fromDate(DateTime.now());
    }
  }
}
