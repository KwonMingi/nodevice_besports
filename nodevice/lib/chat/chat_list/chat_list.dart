import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/chat/chat_list/chat_list_view_model.dart';
import 'package:nodevice/chat/chatroom/chat.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/io/firebase_data_service.dart';

// Ensure this provider is defined somewhere in your codebase
final chatRoomsProvider = ChangeNotifierProvider((ref) {
  String? userId =
      getCurrentUserId(); // This function needs to be defined to fetch the current user's ID
  if (userId != null) {
    return ChatRoomsViewModel(userId);
  } else {
    throw Exception(
        'User ID is null'); // Handle the case where the user ID is not available
  }
});

class ChatRoomsScreen extends ConsumerWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ChatRoomsViewModel를 watch하여 변화를 감지합니다.
    final chatRoomsViewModel = ref.watch(chatRoomsProvider);

    return Scaffold(
      backgroundColor: CustomColors.appColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: CustomColors.appGray,
              child: const Center(),
            ),
          ),
          Expanded(
            flex: 14,
            child: ListView.builder(
              itemCount: chatRoomsViewModel.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRoomsViewModel.chatRooms[index];

                return Card(
                  color: CustomColors.appGray,
                  // ListTile을 Card로 감쌉니다.
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // 카드의 모서리를 둥글게 처리합니다.
                  ),
                  margin: const EdgeInsets.all(8.0), // 카드 간의 간격을 조정합니다.
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chatRoom.imageUrl ?? ''),
                    ),
                    title: FutureBuilder<String?>(
                      future: chatRoomsViewModel
                          .getOtherParticipantFirstName(chatRoom),
                      builder: (BuildContext context,
                          AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            snapshot.data ?? 'Chat Room',
                            style:
                                TextStyle(color: Theme.of(context).canvasColor),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 마지막 메시지 시간 표시
                        // 마지막 메시지 시간 표시
                        FutureBuilder<Timestamp>(
                          future: chatRoomsViewModel
                              .getLatestMessageTimestamp(chatRoom),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Text(
                                chatRoomsViewModel
                                    .formatLastMessageTime(snapshot.data!),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              );
                            } else {
                              return const SizedBox(); // 또는 적절한 로딩/에러 위젯
                            }
                          },
                        ),

                        // 읽지 않은 메시지 수 표시
                        FutureBuilder<int>(
                          future: chatRoomsViewModel
                              .getUnreadMessagesCount(chatRoom),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data! > 0) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${snapshot.data}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              );
                            } else {
                              return const SizedBox
                                  .shrink(); // 읽지 않은 메시지가 없으면 아무것도 표시하지 않음
                            }
                          },
                        ),
                      ],
                    ),
                    subtitle: FutureBuilder<String>(
                      future: chatRoomsViewModel.getLatestMessageText(chatRoom),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // 데이터가 성공적으로 로드되면 최근 메시지를 표시합니다.
                          return Text(
                            snapshot.data!,
                            style:
                                TextStyle(color: Theme.of(context).canvasColor),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 데이터 로딩 중이면 로딩 인디케이터를 표시합니다.
                          return const CircularProgressIndicator();
                        } else {
                          // 데이터 로딩 실패 시 에러 메시지를 표시합니다.
                          return Text(
                            'Failed to load message',
                            style:
                                TextStyle(color: Theme.of(context).canvasColor),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(room: chatRoom)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/createChatRoom');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
