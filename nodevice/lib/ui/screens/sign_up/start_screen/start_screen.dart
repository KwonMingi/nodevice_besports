import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  late RSizes s;

  @override
  Widget build(BuildContext context) {
  s = RSizes(
    MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);  

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 원하는 배경색 지정
      statusBarIconBrightness: Brightness.dark, // 아이콘 색상 설정
      systemNavigationBarColor: custom_colors.loginBackGround, // navigation bar color
    ));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/start_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: s.rSize("height", 700)),
              CustomButton(
                text: '비스포츠 시작하기',
                onPressed: () {
                  widget.controller.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                width: 312,
                height: 48,
                isActivate: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
