import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nodevice/chat/chat_data_struct.dart';
import 'package:nodevice/chat/chatroom/chat_view_model.dart';
import 'package:nodevice/io/firebase_data_service.dart';

final chatViewModelProvider =
    ChangeNotifierProvider.family<ChatViewModel, ChatRoom>(
  (ref, chatRoom) => ChatViewModel(chatRoom.chatRoomId, chatRoom.chatRoomName),
);

class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomId;
  final String chatRoomName;

  const ChatScreen(
      {Key? key, required this.chatRoomId, required this.chatRoomName})
      : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController messageController;
  final ScrollController scrollController = ScrollController();
  late String? uid = getCurrentUserId();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message, WidgetRef ref) {
    if (message.isNotEmpty) {
      final chatRoom = ChatRoom(
          chatRoomId: widget.chatRoomId,
          chatRoomName: widget.chatRoomName,
          participants: []); // 'users' 대신 'participants' 필드를 사용합니다.

      ref
          .read(chatViewModelProvider(chatRoom))
          .sendMessage(message, uid!); // 현재 사용자의 UID를 사용하여 메시지를 보냅니다.
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRoom = ChatRoom(
        chatRoomId: widget.chatRoomId,
        chatRoomName: widget.chatRoomName,
        participants: []);
    final chatViewModel = ref.watch(chatViewModelProvider(chatRoom));

    ref.listen<List<Message>>(
      chatViewModelProvider(chatRoom).select((model) => model.messages),
      (_, __) =>
          scrollController.jumpTo(scrollController.position.maxScrollExtent),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.chatRoomName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              reverse: true, // 리스트를 뒤집어 최신 메시지가 하단에 위치하도록 설정
              itemCount: chatViewModel.messages.length,
              itemBuilder: (context, index) {
                // 인덱스 조정 없이 직접 사용
                final message = chatViewModel.messages[index];
                bool isCurrentUserMessage = message.senderId == uid;

                return Row(
                  mainAxisAlignment: isCurrentUserMessage
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isCurrentUserMessage
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: isCurrentUserMessage
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )
                            : const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                            color: isCurrentUserMessage
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(labelText: 'Enter message'),
                    onSubmitted: (value) => _sendMessage(value, ref),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(messageController.text, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
