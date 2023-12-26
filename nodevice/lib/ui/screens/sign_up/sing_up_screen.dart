import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_google.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_view_model.dart';
import 'package:nodevice/ui/widgets/custom_buttons/custom_sign_in_button.dart';
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

  late RSizes s;
  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: s.rSize("height", 250),
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
                const CustomText(
                  text: 'Sign up',
                  color: Color(0xFF755DC1),
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: s.rSize("height", 70),
                ),
                CustomTextField(
                  controller: model.emailController,
                  labelText: 'Email',
                  labelColor: const Color(0xFF755DC1),
                  borderColor: const Color(0xFF837E93),
                  focusedBorderColor: const Color(0xFF9F7BFF),
                ),
                SizedBox(
                  height: s.rSize("height", 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: model.passController,
                        labelText: 'Password',
                        labelColor: const Color(0xFF755DC1),
                        borderColor: const Color(0xFF837E93),
                        focusedBorderColor: const Color(0xFF9F7BFF),
                        isObscure: true,
                      ),
                    ),
                    const SizedBox(width: 10), // 두 텍스트 필드 사이에 간격 추가
                    Expanded(
                      child: CustomTextField(
                        controller: model.repassController,
                        labelText: 'Confirm Password',
                        labelColor: const Color(0xFF755DC1),
                        borderColor: const Color(0xFF837E93),
                        focusedBorderColor: const Color(0xFF9F7BFF),
                        isObscure: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: s.rSize("height", 30),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                        backgroundColor: const Color(0xFF9F7BFF),
                      ),
                      child: const Text(
                        'Create account',
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
                    backgroundColor: custom_colors.appColor, // 텍스트 및 아이콘 색상
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
                      showSnackbar(
                          context, "Google Sign-In failed: ${e.toString()}");
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      ' have an account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 2.5,
                    ),
                    InkWell(
                      onTap: () {
                        widget.controller.animateToPage(0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: const Text(
                        'Log In ',
                        style: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 13,
                          fontFamily: 'Poppins',
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
    );
  }
}
