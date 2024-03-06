import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nodevice/chat/chat_utils.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/utils/chat_util.dart';
import 'package:rxdart/rxdart.dart';

class ChatRoomViewModel {
  final uid = getCurrentUserId();
  final _roomSubject = BehaviorSubject<types.Room?>();
  Stream<types.Room?> get roomStream => _roomSubject.stream;
  String roomId;

  ChatRoomViewModel(this.roomId);

  void fetchRoom() async {
    final fetchedRoom = await getRoomWithId(roomId);
    _roomSubject.add(fetchedRoom);
  }

  void sendToMessage(String text) {
    sendMessage(roomId, text);
  }

  void dispose() {
    _roomSubject.close();
  }
}
