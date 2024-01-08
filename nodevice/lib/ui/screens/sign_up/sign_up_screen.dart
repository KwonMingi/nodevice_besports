import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';

import 'package:nodevice/ui/screens/sign_up/sign_in_google.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_view_model.dart';
import 'package:nodevice/ui/widgets/loading_dialog.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text_field.dart';
import 'package:nodevice/utils/show_snackbar.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  SignInViewModel model = SignInViewModel();

  final snackbar = SnackbarManager();
  late RSizes s;
  
  bool isButtonActivate() {
    return model.emailController.text.isNotEmpty && model.passController.text.isNotEmpty && model.repassController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: custom_colors.loginBackGround,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: s.rSize("height", 180),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 0),
            //   child: Image.asset(
            //     "assets/images/vector-2.png",
            //     width: s.rSize("width", 1000),
            //     height: s.rSize("height", 500),
            //   ),
            // ),
            // const SizedBox(
            //   height: 18,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      widget.controller.animateToPage(1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0), // 여기에서 패딩 값을 조정하여 히트박스 크기 조절
                      child: Image.asset('assets/icons/sign_up_back_icon.png'),
                    ),
                  ),
                  SizedBox(
                    height: s.rSize("height", 70),
                  ),
                  
                  const CustomText(
                    text: '회원가입',
                    color: Color(0xFFC2C2C2),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: s.rSize("height", 5),
                  ),

                  const CustomText(
                    text: '이메일과 비밀번호를 입력해주세요',
                    color: Color(0xFFC2C2C2),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: s.rSize("height", 70),
                  ),

                  CustomTextField(
                    controller: model.emailController,
                    labelText: '이메일',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6bd20f),
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(
                    height: s.rSize("height", 30),
                  ),

                  CustomTextField(
                    controller: model.passController,
                    labelText: '비밀번호',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6bd20f),
                    isObscure: true,
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(
                    height: s.rSize("height", 30),
                  ),

                  CustomTextField(
                    controller: model.repassController,
                    labelText: '비밀번호 재확인',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6bd20f),
                    isObscure: true,
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(
                    height: s.rSize("height", 30),
                  ),

                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(33.5)),
                    child: SizedBox(
                      width: s.rSize("width", 1000),
                      height: s.rSize("height", 70),
                      child: ElevatedButton(
                        onPressed: () async {
                          await model.createAccount(context);
                          // widget.controller.animateToPage(2,
                          //     duration: const Duration(milliseconds: 500),
                          //     curve: Curves.ease);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonActivate() ? const Color(0xFF6BD20F) : const Color(0xFF3C403A),
                        ),
                        child: const Text(
                          '회원 가입',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF3C403A), // 텍스트 및 아이콘 색상
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
