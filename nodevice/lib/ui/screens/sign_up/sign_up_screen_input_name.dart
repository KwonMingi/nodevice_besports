import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/constants/r_sizes.dart';

import 'package:nodevice/ui/screens/sign_up/profile/profile_view_model.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_button.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_text_field.dart';
import 'package:nodevice/utils/show_snackbar.dart';

class SignUpNameScreen extends StatefulWidget {
  const SignUpNameScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<SignUpNameScreen> createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  ProfileViewModel model = ProfileViewModel();

  final snackbar = SnackbarManager();
  late RSizes s;
  
  bool isButtonActivate() {
    return model.lastNameController.text.isNotEmpty && model.firstNameController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 원하는 배경색 지정
      statusBarIconBrightness: Brightness.light, // 아이콘 색상 설정
    ));

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
                      widget.controller.animateToPage(2,
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
                    text: '성과 이름을 입력해주세요',
                    color: Color(0xFFC2C2C2),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: s.rSize("height", 100),
                  ),

                  CustomTextField(
                    controller: model.lastNameController,
                    labelText: '성',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6bd20f),
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(
                    height: s.rSize("height", 30),
                  ),

                  CustomTextField(
                    controller: model.firstNameController,
                    labelText: '이름',
                    labelColor: const Color(0xFFC2C2C2),
                    borderColor: const Color(0xFF837E93),
                    focusedBorderColor: const Color(0xFF6bd20f),
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(
                    height: s.rSize("height", 100),
                  ),
                  CustomButton(
                    text: '다음',
                    onPressed: () {
                      widget.controller.animateToPage(4,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    width: s.rSize("width", 1000),
                    height: s.rSize("height", 70),
                    isActivate: isButtonActivate(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
