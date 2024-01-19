import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/constants/custom_colors.dart';

import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_button.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nodevice/ui/widgets/loading_dialog.dart';

import 'package:nodevice/ui/screens/sign_up/sign_in_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nodevice/utils/show_snackbar.dart';

class StartSelectScreen extends StatefulWidget {
  const StartSelectScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<StartSelectScreen> createState() => _StartSelectScreenState();
}

class _StartSelectScreenState extends State<StartSelectScreen> {
  late RSizes s;
  final snackbar = SnackbarManager();

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 원하는 배경색 지정
      statusBarIconBrightness: Brightness.light, // 아이콘 색상 설정
      systemNavigationBarColor: CustomColors.loginBackGround,
    ));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/start_background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: s.rSize("height", 500)),
              SizedBox(
                width: 312,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    '구글 계정으로 계속',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(33.5)),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      showLoadingDialog(context);
                      UserCredential userCredential = await signInWithGoogle();
                      Navigator.of(context).pop();
                      if (userCredential.user != null) {
                        GoRouter.of(context).replace('/home');
                      }
                      // 로그인 성공 후 처리
                    } catch (e) {
                      Navigator.of(context).pop(); // 오류 발생 시 로딩 다이얼로그 닫기
                      snackbar.showSnackbar(
                          "Google Sign-In failed: ${e.toString()}");
                    }
                  },
                ),
              ),
              SizedBox(height: s.rSize("height", 200)),
              CustomButton(
                text: '회원가입',
                onPressed: () {
                  widget.controller.animateToPage(3,
                      duration: const Duration(milliseconds: 5),
                      curve: Curves.ease);
                },
                width: 312,
                height: 48,
                isActivate: true,
              ),
              SizedBox(height: s.rSize("height", 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: '비스포츠를 이용해보셨나요?',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    onTap: () {
                      widget.controller.animateToPage(2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0), // 탭 가능 영역을 늘리기 위한 패딩
                      child: CustomText(
                        text: '로그인',
                        color: Color(0xFF6BD20F),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
