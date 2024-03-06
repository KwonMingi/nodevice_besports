import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class ChatRoomsViewModel extends ChangeNotifier {
  final List<types.Room> _chatRooms = [];
  final String currentUserId; // 현재 사용자 ID

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
}
