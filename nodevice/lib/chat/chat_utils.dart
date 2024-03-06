import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

void sendMessage(String roomId, String text) async {
  try {
    // 현재 사용자 가져오기 (FirebaseChatCore가 이를 처리함)
    final user = FirebaseChatCore.instance.firebaseUser;

    // 텍스트 메시지 객체 생성
    final textMessage = types.TextMessage(
      author: types.User(id: user?.uid ?? ''),
      createdAt: DateTime.now()
          .millisecondsSinceEpoch, // 혹은 서버 시간을 사용하려면 Firebase 서버 타임스탬프를 사용하세요
      id: const Uuid().v4(), // 메시지 ID, 여기서는 Uuid 패키지를 사용해 생성
      text: text, // 보낼 텍스트
    );

    // FirebaseChatCore를 사용하여 메시지 보내기
    FirebaseChatCore.instance.sendMessage(
      textMessage,
      roomId, // 대상 채팅방 ID
    );
  } catch (e) {
    print("메시지 전송 중 에러 발생: $e");
  }
}
