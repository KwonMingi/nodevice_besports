import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/chat/chat_list/chat_list.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/on_memory_data.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/ui/screens/display_record/calendar_screen.dart';
import 'package:nodevice/ui/screens/display_record/record_routin_screen.dart';
import 'package:nodevice/ui/screens/exercise_record/exercise_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    initProfile();
    ExerciseStatus.loadUserData(getCurrentUserId()!);
  }

  void initProfile() async {
    await UserProfileOnMemory.loadUserProfile();
  }

  final List<Widget> _widgetOptions = [
    const RecordRoutinScreen(),
    const ExerciseScreen(),
    const CalendarScreen(),
    const ChatRoomsScreen(),
    const Text('Profile Tab'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).replace('/home');
        break;
      case 1:
        GoRouter.of(context).replace('/exercise');
        break;
      case 2:
        GoRouter.of(context).replace('/calendar');
        break;
      case 3:
        GoRouter.of(context).replace('/chat');
        break;
      case 4:
        GoRouter.of(context).replace('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // 현재 선택된 인덱스
        onTap: _onItemTapped, // 탭을 클릭할 때 호출될 함수
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '활동',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '분석',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '나',
          ),
        ],
        // 아이템 선택 시 색상 변경
        selectedItemColor: CustomColors.appGreen,
        unselectedItemColor: ThemeData.light().canvasColor,
        backgroundColor: CustomColors.appGray,
        type: BottomNavigationBarType.fixed, // 모든 아이템이 고정된 크기를 가짐
      ),
    );
  }
}
