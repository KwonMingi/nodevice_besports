import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';

import 'package:nodevice/ui/screens/sign_up/sign_in_view_model.dart';
import 'package:nodevice/ui/widgets/loading_dialog.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_button.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text_field.dart';
import 'package:nodevice/utils/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late RSizes s;
  SignInViewModel model = SignInViewModel();
  bool isAutoLogin = false; // 자동 로그인 상태 변수 추가
  final snackbar = SnackbarManager();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        model.loadAutoLogin(context);
      }
    });
  }

  // void autoLogin() {
  //   showLoadingDialog(context);
  //   try {
  //     model.loadAutoLogin(context);
  //   } catch (e) {
  //     showSnackbar(context, 'not Access');
  //   } finally {
  //     Navigator.of(context).pop();
  //   }
  // }
  bool isButtonActivate() {
    return model.emailController.text.isNotEmpty &&
        model.passController.text.isNotEmpty;
  }

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
      backgroundColor: CustomColors.loginBackGround,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: s.rSize("height", 150)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/besports_login_icon.png'),
                  SizedBox(height: s.rSize("height", 20)),
                  const CustomText(
                    text: 'Unlock your Potential',
                    color: Color(0xFFC2C2C2),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: s.rSize("height", 270)),
                  CustomTextField(
                    controller: model.emailController,
                    labelText: '이메일',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6BD20F),
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(height: s.rSize("height", 30)),
                  CustomTextField(
                    controller: model.passController,
                    labelText: '비밀번호',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6BD20F),
                    isObscure: true,
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(height: s.rSize("height", 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              const Color(0xFF6BD20F), // 기본 체크박스 색상 설정
                        ),
                        child: Checkbox(
                          value: isAutoLogin,
                          onChanged: (bool? value) {
                            setState(() {
                              isAutoLogin = value ?? false;
                              model.setAutoLoginChecked =
                                  isAutoLogin; // 모델에 상태 업데이트
                            });
                          },
                          activeColor:
                              const Color(0xFF6BD20F), // 활성 상태의 체크박스 색상 설정
                          checkColor: Colors.white, // 체크 표시 색상 설정
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isAutoLogin = !isAutoLogin;
                            model.setAutoLoginChecked =
                                isAutoLogin; // 모델에 상태 업데이트
                          });
                        },
                        child: const Text(
                          "자동 로그인",
                          style: TextStyle(
                            color: Color(0xFF6BD20F), // 텍스트 색상 설정
                            fontSize: 14, // 텍스트 크기 설정
                          ),
                        ),
                      ),
                      const SizedBox(width: 80.0),
                      InkWell(
                        onTap: () async {
                          // Display a dialog to get the user's email
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController emailResetController =
                                  TextEditingController();
                              return AlertDialog(
                                backgroundColor: CustomColors.loginBackGround,
                                title: const CustomText(
                                  text: 'Reset Password',
                                  color: Color(0xFFC2C2C2),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                content: CustomTextField(
                                  controller: emailResetController,
                                  labelText: 'Email',
                                  labelColor: const Color(0xFFC2C2C2),
                                  borderColor: const Color(0xFF837E93),
                                  focusedBorderColor: const Color(0xFF6BD20F),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Send Reset Link"),
                                    onPressed: () async {
                                      try {
                                        showLoadingDialog(context);
                                        await model.resetPassword(
                                            context, emailResetController.text);
                                        snackbar.showSnackbar("Success");
                                      } finally {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const CustomText(
                          text: '비밀번호 찾기',
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: s.rSize("height", 10)),
                  CustomButton(
                    text: '로그인',
                    onPressed: () async {
                      showLoadingDialog(context); // 로딩 다이얼로그 표시
                      try {
                        if (isAutoLogin) {
                          model.saveAutoLogin();
                        }
                        await model.emailSignIn(context); // 로그인 시도
                      } catch (e) {
                        // 에러 처리 (예: 사용자에게 메시지 표시)
                      } finally {
                        Navigator.of(context).pop(); // 항상 로딩 다이얼로그 닫기
                      }
                    },
                    width: s.rSize("width", 1000),
                    height: s.rSize("height", 70),
                    isActivate: isButtonActivate(),
                  ),
                  SizedBox(height: s.rSize("height", 30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: '비스포츠가 처음이신가요?',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(width: 2),
                      InkWell(
                        onTap: () {
                          widget.controller.animateToPage(3,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0), // 탭 가능 영역을 늘리기 위한 패딩
                          child: CustomText(
                            text: '회원가입',
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
          ],
        ),
      ),
    );
  }
}
