// app_router.dart
import 'package:go_router/go_router.dart';
import 'package:nodevice/chat/chat_list/create_chat_room.dart';
import 'package:nodevice/chat/chatroom/chat_room_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nodevice/ui/screens/display_record/history_screen.dart';
import 'package:nodevice/ui/screens/display_record/select_exercise_equipment_screen.dart';
import 'package:nodevice/ui/screens/exercise_record/record_screen.dart';
import 'package:nodevice/ui/screens/home_screen/home_screen.dart';
import 'package:nodevice/ui/screens/home_screen/main_view.dart';
import 'package:nodevice/utils/chat_util.dart';

class AppRouter {
  static final goRouter = GoRouter(
    initialLocation: '/main',
    routes: [
      GoRoute(
        name: 'main',
        path: '/main',
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const HomeScreen(initialIndex: 0),
      ),
      GoRoute(
        name: 'recommend',
        path: '/recommend',
        builder: (context, state) => const HomeScreen(initialIndex: 1),
      ),
      GoRoute(
        name: 'chat',
        path: '/chat',
        builder: (context, state) => const HomeScreen(initialIndex: 2),
      ),
      GoRoute(
        name: 'calendar',
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
        path: '/select',
        builder: (context, state) => const SelectExerciseEquipmentScreenState(),
      ),
      GoRoute(
        path: '/createChatRoom',
        builder: (context, state) => const CreateChatPage(),
      ),
      // GoRoute(
      //   path: '/add',
      //   builder: (context, state) => const ExerciseScreen(),
      // ),
      // app_router.dart
      GoRoute(
        path: '/chatroom/:chatRoomId',
        builder: (context, state) {
          final chatRoomId = state.pathParameters['chatRoomId']!;
          // ChatRoomPage에 chatRoomId만 전달합니다.
          return ChatRoomPage(chatRoomId: chatRoomId);
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
