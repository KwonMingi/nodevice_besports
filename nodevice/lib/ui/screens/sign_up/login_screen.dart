import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_google.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_view_model.dart';
import 'package:nodevice/ui/widgets/custom_buttons/custom_sign_in_button.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      model.loadAutoLogin(context);
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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: s.rSize("height", 150)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Log In',
                  color: custom_colors.appColor,
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: s.rSize("height", 70)),
                CustomTextField(
                  controller: model.emailController,
                  labelText: 'Email',
                  labelColor: custom_colors.appColor,
                  borderColor: const Color(0xFF837E93),
                  focusedBorderColor: const Color(0xFF9F7BFF),
                ),
                SizedBox(height: s.rSize("height", 40)),
                CustomTextField(
                  controller: model.passController,
                  labelText: 'Password',
                  labelColor: custom_colors.appColor,
                  borderColor: const Color(0xFF837E93),
                  focusedBorderColor: const Color(0xFF9F7BFF),
                  isObscure: true,
                ),
                SizedBox(height: s.rSize("height", 40)),
                CustomButton(
                  text: 'Sign In',
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
                SizedBox(height: s.rSize("height", 1)),
                CheckboxListTile(
                  title: const Text("자동 로그인"),
                  value: isAutoLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      isAutoLogin = value ?? false;
                      model.setAutoLoginChecked = isAutoLogin; // 모델에 상태 업데이트
                    });
                  },
                ),
                Row(
                  children: [
                    const CustomText(
                      text: 'Don’t have an account?',
                      color: Color(0xFF837E93),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 2.5),
                    InkWell(
                      onTap: () {
                        widget.controller.animateToPage(1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: const CustomText(
                        text: 'Sign Up',
                        color: custom_colors.appColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: s.rSize("height", 20)),
                InkWell(
                  onTap: () async {
                    // Display a dialog to get the user's email
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController emailResetController =
                            TextEditingController();
                        return AlertDialog(
                          title: const Text("Reset Password"),
                          content: CustomTextField(
                            controller: emailResetController,
                            labelText: 'Email',
                            labelColor: const Color(0xFF755DC1),
                            borderColor: const Color(0xFF837E93),
                            focusedBorderColor: const Color(0xFF9F7BFF),
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
                                  showSnackbar(context, "Success");
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
                    text: 'Forget Password?',
                    color: Color(0xFF755DC1),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: s.rSize("height", 50),
                ),
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
                      showSnackbar(
                          context, "Google Sign-In failed: ${e.toString()}");
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
