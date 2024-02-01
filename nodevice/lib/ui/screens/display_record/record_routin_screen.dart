import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:flutter/scheduler.dart';
import 'package:nodevice/ui/screens/display_record/history_screen.dart';

class RecordRoutinScreen extends StatefulWidget {
  const RecordRoutinScreen({super.key});

  @override
  State<RecordRoutinScreen> createState() => _RecordRoutinScreenState();
}

class _RecordRoutinScreenState extends State<RecordRoutinScreen> {
  int _selectedIndex = 0;
  late DateTime _currentDate;
  late ScrollController _scrollController;
  late List<DateTime> _dateList;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _dateList = getWeekDays(_currentDate);
    _scrollController =
        ScrollController(initialScrollOffset: _getInitialScrollOffset());
  }

  @override
  Widget build(BuildContext context) {
    // Get current date
    double screenWidth = MediaQuery.of(context).size.width;
    double underlineWidth = screenWidth / 3; // 세 개의 버튼이므로 화면 너비의 1/3
    double underlineLeftPadding =
        _selectedIndex * underlineWidth; // 선택된 인덱스에 따라 왼쪽 여백 조정

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: CustomColors.appGray, // 상단 상태 바 색상 설정
        systemNavigationBarColor: CustomColors.appGray, // 하단 네비게이션 바 색상 설정
        statusBarIconBrightness:
            Brightness.light, // 상태 바 아이콘 밝기 설정 (어두운 색상의 배경에 맞게 밝게)
        systemNavigationBarIconBrightness:
            Brightness.light, // 네비게이션 바 아이콘 밝기 설정 (어두운 색상의 배경에 맞게 밝게)
      ),
      child: Scaffold(
        body: Container(
          color: CustomColors.appGray,
          child: Column(
            children: [
              Flexible(
                flex: 25,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        14,
                        60,
                        0,
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd').format(_currentDate),
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            // Icons on the right
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications,
                                  color: Theme.of(context)
                                      .canvasColor, // Set the icon color
                                ), // Notification icon
                                onPressed: () {
                                  // Handle notification icon press
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context)
                                      .canvasColor, // Set the icon color
                                ), // More icon
                                onPressed: () {
                                  // Handle more icon press
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent) {
                            _addNewDates(true);
                          }
                          if (notification.metrics.pixels <=
                              notification.metrics.minScrollExtent) {
                            _addNewDates(false);
                          }
                          return true;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _dateList.length,
                          itemBuilder: (context, index) {
                            return _buildDateTile(_dateList[index]);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 75,
                      child: Container(
                        color: CustomColors.appDarkColor,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildBottomNavigationButton(0, '운동'),
                                _buildBottomNavigationButton(1, '식단'),
                                _buildBottomNavigationButton(2, '일지'),
                              ],
                            ),
                            SizedBox(
                              // Wrap the Stack in a Container
                              height: 4, // Set a fixed height for the underline
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 150),
                                    left: underlineLeftPadding,
                                    curve: Curves.easeInOut,
                                    child: Container(
                                      height: 2,
                                      width: underlineWidth,
                                      color: CustomColors.appGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: IndexedStack(
                                index: _selectedIndex,
                                children: <Widget>[
                                  HistoryScreen(
                                    key: ValueKey(DateFormat('yyyy-MM-dd')
                                        .format(_currentDate)),
                                    date: DateFormat('yyyy-MM-dd')
                                        .format(_currentDate),
                                  ),

                                  // 나머지 스크린 위젯들
                                  Text(
                                    '식단',
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                  Text(
                                    '일지',
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DateTime> getWeekDays(DateTime dateTime) {
    DateTime startOfWeek =
        dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  void _addNewDates(bool nextWeek) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (nextWeek) {
        setState(() {
          DateTime newEnd = _dateList.last.add(const Duration(days: 7));
          for (DateTime d = _dateList.last.add(const Duration(days: 1));
              d.isBefore(newEnd);
              d = d.add(const Duration(days: 1))) {
            _dateList.add(d);
          }
        });
      } else {
        setState(() {
          DateTime newStart = _dateList.first.subtract(const Duration(days: 7));
          for (DateTime d = _dateList.first.subtract(const Duration(days: 1));
              d.isAfter(newStart);
              d = d.subtract(const Duration(days: 1))) {
            _dateList.insert(0, d);
          }
        });
        // 스크롤 위치를 조정하는 로직도 여기에 포함시킵니다.
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 420.0);
      }
    });
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _currentDate = selectedDate;
      _selectedIndex = 0; // HistoryScreen이 0번 인덱스라고 가정

      int index = _dateList.indexOf(selectedDate);
      double offset = index * 60.0 - MediaQuery.of(context).size.width / 2 + 30;
      _scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    });
  }

  void _onScrollEnd(ScrollMetrics metrics) {
    double middleOfScreen =
        metrics.pixels + MediaQuery.of(context).size.width / 2;
    int closestIndex = (middleOfScreen / 60.0).round();
    closestIndex = closestIndex.clamp(0, _dateList.length - 1);
    double offset =
        closestIndex * 60.0 - MediaQuery.of(context).size.width / 2 + 30;
    _scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  double _getInitialScrollOffset() {
    int daysBeforeCurrent = _dateList.indexOf(_currentDate);
    double offset = (daysBeforeCurrent - 3) * 60.0;
    return offset > 0 ? offset : 0.0;
  }

  Widget _buildBottomNavigationButton(int index, String label) {
    bool isSelected = _selectedIndex == index;
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? CustomColors.appGreen : Colors.grey,
        padding: EdgeInsets.zero,
      ),
      child: Text(label),
    );
  }

  Widget _buildDateTile(DateTime day) {
    bool isSelected = DateFormat('yyyy-MM-dd').format(day) ==
        DateFormat('yyyy-MM-dd').format(_currentDate);
    String dayOfWeek = DateFormat('EEE', 'ko').format(day);

    Color textColor;
    if (dayOfWeek == "토") {
      textColor = Colors.blue; // 토요일에는 파란색
    } else if (dayOfWeek == "일") {
      textColor = Colors.red; // 일요일에는 빨간색
    } else {
      textColor = isSelected
          ? CustomColors.appGreen
          : Theme.of(context).canvasColor; // 그 외의 요일
    }

    return GestureDetector(
      onTap: () => _onDateSelected(day),
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 60,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              DateFormat('EEE', 'ko').format(day),
              style: TextStyle(
                color: isSelected ? CustomColors.appGreen : textColor,
              ),
            ),
            Text(
              DateFormat('d').format(day),
              style: TextStyle(
                color: isSelected ? CustomColors.appGreen : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
