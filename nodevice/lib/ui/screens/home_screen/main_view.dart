import 'package:flutter/material.dart';
import 'package:nodevice/ui/screens/sign_up/login_screen.dart';
import 'package:nodevice/ui/screens/sign_up/sign_up_screen.dart';
import 'package:nodevice/ui/screens/sign_up/sign_up_screen_input_name.dart';
import 'package:nodevice/ui/screens/sign_up/start_screen/start_screen.dart';
import 'package:nodevice/ui/screens/sign_up/start_screen/start_select_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return StartScreen(
              controller: controller,
            );
          } else if (index == 1) {
            return StartSelectScreen(
              controller: controller,
            );
          } else if (index == 2) {
            return LoginScreen(
              controller: controller,
            );
          } else if (index == 3) {
            return SignUpNameScreen(
              controller: controller,
            );
          } else if (index == 4) {
            return SignUpScreen(
              controller: controller,
            );
          }
          return null;
          // else {
          //   return VerifyScreen(
          //     controller: controller,
          //   );
          // }
        },
      ),
    );
  }
}
