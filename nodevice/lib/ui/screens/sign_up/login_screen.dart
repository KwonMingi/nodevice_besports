import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_google.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_view_model.dart';
import 'package:nodevice/ui/widgets/custom_buttons/custom_sign_in_button.dart';
import 'package:nodevice/ui/widgets/custom_buttons/login_button_test.dart';
import 'package:nodevice/ui/widgets/loading_dialog.dart';
// import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_button.dart';
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

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    
    return Scaffold(
      backgroundColor: custom_colors.loginBackGround,
      
      body: Column(
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
                const CustomText(
                  text: '당신의 건강을 위해 비스포츠는 함께합니다',
                  color: Color(0xFFC2C2C2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: s.rSize("height", 70)),

                CustomTextField(
                  controller: model.emailController,
                  labelText: '이메일',
                  labelColor: const Color(0xFFC2C2C2),
                  borderColor: const Color(0xFF837E93),
                  focusedBorderColor: const Color(0xFF6BD20F),
                ),
                SizedBox(height: s.rSize("height", 40)),

                CustomTextField(
                  controller: model.passController,
                  labelText: '비밀번호',
                  labelColor: const Color(0xFFC2C2C2),
                  borderColor: const Color(0xFF837E93),
                  focusedBorderColor: const Color(0xFF6BD20F),
                  isObscure: true,
                ),
                SizedBox(height: s.rSize("height", 30)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: isAutoLogin,
                      onChanged: (bool? value) {
                        setState(() {
                          isAutoLogin = value ?? false;
                          model.setAutoLoginChecked = isAutoLogin; // 모델에 상태 업데이트
                        });
                      },
                      activeColor: const Color(0xFF6BD20F),
                      checkColor: Colors.white, // 체크박스 활성 상태의 색상 설정
                    ),
                    const Text(
                      "자동 로그인",
                      style: TextStyle(
                        color: Color(0xFF6BD20F), // 텍스트 색상 설정
                        fontSize: 14, // 텍스트 크기 설정
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
                              backgroundColor: custom_colors.loginBackGround,
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

                CustomButtonTest(
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
                ),
                SizedBox(height: s.rSize("height", 30)),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: '비스포츠가 처음이신가요?',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 10),
                    
                    InkWell(
                      onTap: () {
                        widget.controller.animateToPage(1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: const CustomText(
                        text: '회원가입',
                        color: Color(0xFF6BD20F),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: s.rSize("height", 50)),

                CustomSignInButton(
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
                  message: "sign in with google",
                  height: 40,
                  width: s.rSize("width", 1000),
                  foregroundColor: Colors.white,
                  backgroundColor: custom_colors.appColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
