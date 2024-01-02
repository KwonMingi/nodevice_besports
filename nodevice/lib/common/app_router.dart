// app_router.dart
import 'package:go_router/go_router.dart';
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
        path: '/history',
        builder: (context, state) => const HomeScreen(initialIndex: 2),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const HomeScreen(initialIndex: 3),
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
