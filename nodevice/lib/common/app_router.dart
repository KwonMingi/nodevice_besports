// app_router.dart
import 'package:go_router/go_router.dart';
import 'package:nodevice/chat/chat_list/create_chat_room.dart';
import 'package:nodevice/chat/chatroom/chat_screen.dart';
import 'package:nodevice/ui/screens/display_record/history_screen.dart';
import 'package:nodevice/ui/screens/exercise_record/exercise_screen.dart';
import 'package:nodevice/ui/screens/exercise_record/record_screen.dart';
import 'package:nodevice/ui/screens/home_screen/home_screen.dart';
import 'package:nodevice/ui/screens/home_screen/main_view.dart';

class AppRouter {
  static final goRouter = GoRouter(
    initialLocation: '/main',
    routes: [
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(initialIndex: 0),
      ),
      GoRoute(
        path: '/exercise',
        builder: (context, state) => const HomeScreen(initialIndex: 1),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const HomeScreen(initialIndex: 2),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const HomeScreen(
          initialIndex: 3,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const HomeScreen(initialIndex: 4),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) {
          // extra를 사용하여 전달된 날짜를 받아옵니다.
          final String date = state.extra as String? ?? '';

          return HistoryScreen(date: date);
        },
      ),
      GoRoute(
        path: '/createChatRoom',
        builder: (context, state) => const CreateChatRoomScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const ExerciseScreen(),
      ),
      GoRoute(
        path: '/chatroom/:chatRoomId',
        builder: (context, state) {
          final chatRoomId = state.pathParameters['chatRoomId'] ?? '';
          final chatRoomName =
              state.extra as String? ?? ''; // 채팅방 이름을 extra에서 가져옵니다.

          return ChatScreen(chatRoomId: chatRoomId, chatRoomName: chatRoomName);
        },
      ),
      GoRoute(
        path: '/record',
        builder: (context, state) {
          final args =
              state.extra as Map<String, dynamic>? ?? {}; // null 검사 및 기본값 설정

          // args에서 값을 안전하게 추출하고, 기본값을 제공합니다.
          final int setCount = args['setCount'] as int? ?? 0;
          final String exerciseType = args['exerciseType'] as String? ?? '';
          final int restTime = args['restTime'] as int? ?? 0;

          return RecordScreen(
            setCount: setCount,
            exerciseType: exerciseType,
            restTime: restTime,
          );
        },
      ),

      // 추가 경로를 여기에 정의할 수 있습니다.
    ],
  );
}
