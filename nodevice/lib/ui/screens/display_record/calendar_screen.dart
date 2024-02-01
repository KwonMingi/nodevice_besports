import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/constants/on_memory_data.dart';
import 'package:nodevice/ui/screens/display_record/history_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late RSizes s;

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month; // 달력 형식 상태 추가

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat, // 현재 달력 형식 사용
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            _showSelectedDateModal(selectedDay);
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format; // 달력 형식 상태 업데이트
              });
            }
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              var exercisesOnDate = ExerciseStatus.user
                  .findExercisesByDate(DateFormat('yyyy-MM-dd').format(date));

              if (exercisesOnDate.isNotEmpty) {
                // 운동 기록이 있는 날짜에 마커 표시
                return Positioned(
                  bottom: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF9F7BFF),
                    ),
                    width: 7,
                    height: 7,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  void _showSelectedDateModal(DateTime selectedDay) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 모달창의 배경을 투명하게 설정
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SizedBox(
            height: s.rSize('height', 800),
            child: HistoryScreen(date: formattedDate),
          ),
        );
      },
    );
  }
}
