import 'dart:async';
import 'package:flutter/material.dart';

class RestTimeModal extends StatefulWidget {
  final int restTime;

  const RestTimeModal({Key? key, required this.restTime}) : super(key: key);

  @override
  _RestTimeModalState createState() => _RestTimeModalState();
}

class _RestTimeModalState extends State<RestTimeModal> {
  late ValueNotifier<int> remainingTimeNotifier;

  @override
  void initState() {
    super.initState();
    remainingTimeNotifier = ValueNotifier(widget.restTime);
    startTimer();
  }

  @override
  void dispose() {
    remainingTimeNotifier.dispose();
    super.dispose();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (remainingTimeNotifier.value > 0) {
        remainingTimeNotifier.value--;
      } else {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '휴식 시간',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<int>(
              valueListenable: remainingTimeNotifier,
              builder: (context, value, child) {
                return Text(
                  '$value초 남음',
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('계속하기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
