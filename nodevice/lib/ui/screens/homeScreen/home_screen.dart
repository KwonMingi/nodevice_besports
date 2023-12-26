import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/ui/screens/exerciseRecord/exercise_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nodevice/ui/screens/display_record/historyScreen.dart';

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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _widgetOptions = [
    const Text('Home Tab'),
    const ExerciseScreen(),
    const HistoryScreen(),
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
        GoRouter.of(context).replace('/history');
        break;
      case 3:
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
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 0
                ? Colors.amber.shade100
                : ThemeData.light().canvasColor,
          ),
          Icon(
            Icons.fitness_center,
            size: 30,
            color: _selectedIndex == 1
                ? Colors.amber.shade100
                : ThemeData.light().canvasColor,
          ),
          Icon(
            Icons.calendar_today,
            size: 30,
            color: _selectedIndex == 2
                ? Colors.amber.shade100
                : ThemeData.light().canvasColor,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _selectedIndex == 3
                ? Colors.amber.shade100
                : ThemeData.light().canvasColor,
          ),
        ],
        color: const Color(0xFF9F7BFF),
        buttonBackgroundColor: const Color(0xFF9F7BFF),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 100),
        onTap: _onItemTapped,
      ),
    );
  }
}
