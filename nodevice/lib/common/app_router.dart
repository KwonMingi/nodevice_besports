// app_router.dart
import 'package:go_router/go_router.dart';
import 'package:nodevice/ui/screens/exerciseRecord/recordScreen.dart';
import 'package:nodevice/ui/screens/homeScreen/homeScreen.dart';
import 'package:nodevice/ui/screens/homeScreen/main_view.dart';

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
          final args = state.extra as Map<String, dynamic>;
          return RecordScreen(
            setCount: args['setCount'],
            exerciseType: args['exerciseType'],
          );
        },
      ),
      // 추가 경로를 여기에 정의할 수 있습니다.
    ],
  );
}
