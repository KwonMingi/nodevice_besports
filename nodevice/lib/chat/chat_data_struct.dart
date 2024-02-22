import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  late final String _chatRoomId;
  late final String _chatRoomName;
  late final List<dynamic> _participants;

  ChatRoom({required chatRoomId, required chatRoomName, required participants})
      : _chatRoomId = chatRoomId,
        _chatRoomName = chatRoomName,
        _participants = participants;

  void addUser(String uid) {
    _participants.add(uid);
  }

  String get chatRoomName => _chatRoomName;
  String get chatRoomId => _chatRoomId;
  List<dynamic> get users => _participants;
  set setChatRoomName(String name) => _chatRoomName = name;
  set setUsers(List<dynamic> participants) => _participants = participants;
}

class Message {
  String _id;
  String _text;
  String _senderId;
  Timestamp _timestamp;

  Message({required id, required text, required senderId, required timestamp})
      : _id = id,
        _text = text,
        _senderId = senderId,
        _timestamp = timestamp;

  String get id => _id;
  String get text => _text;
  String get senderId => _senderId;
  Timestamp get timestamp => _timestamp;
  set setId(String id) => _id = id;
  set setText(String text) => _text = text;
  set setSenderId(String senderId) => _senderId = senderId;
  set setTimestamp(Timestamp time) => _timestamp = time;
}
