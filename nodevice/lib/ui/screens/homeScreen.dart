import 'package:flutter/material.dart';
import 'package:nodevice/ui/screens/exerciseScreen.dart';
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // 아이콘에 해당하는 화면을 여기에 추가하세요.
  final List<Widget> _widgetOptions = [
    const Text('Home Tab'),
    const ExerciseScreen(),
    const Text('Favorites Tab'),
    const Text('Profile Tab'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            color: _selectedIndex == 0 ? Colors.amber.shade100 : Colors.white,
          ),
          Icon(
            Icons.fitness_center,
            size: 30,
            color: _selectedIndex == 1 ? Colors.amber.shade100 : Colors.white,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: _selectedIndex == 2 ? Colors.amber.shade100 : Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _selectedIndex == 3 ? Colors.amber.shade100 : Colors.white,
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
