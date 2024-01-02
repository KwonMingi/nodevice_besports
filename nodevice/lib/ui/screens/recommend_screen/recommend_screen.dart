import 'package:flutter/material.dart';

import 'package:nodevice/constants/r_gaps.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/constants/custom_colors.dart';

import 'package:nodevice/ui/screens/recommend_screen/recommend_view_model.dart';


class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  static const routeName = '/recommend';
  static const routeURL = '/recommend';

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  late RSizes s;
  late RGaps g;

  final ValueNotifier<int> _selectGender = ValueNotifier<int>(-1);
  final ValueNotifier<int> _selectGoal = ValueNotifier<int>(-1);
  final ValueNotifier<int> _selectDivide = ValueNotifier<int>(-1);
  final ValueNotifier<List<int>> _selectPart = ValueNotifier<List<int>>([]);
  final ValueNotifier<int> _selectTime = ValueNotifier<int>(-1);

  String answerPrint = "";
  String responsePrint = "-";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return SafeArea(
      child: Scaffold(
        backgroundColor: custom_colors.backgroundDarkWhite,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(s.hrSize10()),
          child: AppBar(
            backgroundColor: custom_colors.backgroundDarkWhite,
            flexibleSpace: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'Images/logo_green.png',
                height: s.hrSize04(),
                width: s.wrSize10(),
                fit: BoxFit.fill,
              ),
            ),
            elevation: 0,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: s.hrSize03()),
              child: Column(
                children: [
                  g.vr02(),
                  Text(
                    'Workout Recommend',
                    style: TextStyle(
                      color: custom_colors.backgroundLightBlack,
                      fontSize: s.hrSize028(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            g.vr01(),
            Row(
              children: [
                SizedBox(
                  width: s.wrSize16(),
                  child: Text(
                    "성별 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectButton(
                  type: _selectGender,
                  typeChoice: 0,
                  w: s.wrSize37(),
                  h: s.hrSize05(),
                  text: "남자",
                ),
                g.hr05(),
                selectButton(
                  type: _selectGender,
                  typeChoice: 1,
                  w: s.wrSize37(),
                  h: s.hrSize05(),
                  text: "여자",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize14(),
                  child: Text(
                    "목적 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 0,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "다이어트",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 1,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "근성장",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 2,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "체중유지",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "수행능력 향상",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize14(),
                  child: Text(
                    "분할 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 0,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "무분할",
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 1,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "2분할",
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 2,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "3분할",
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "5분할",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize12(),
                  child: Text(
                    "부위 :\n(복수선택)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 0,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "팔",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 1,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "가슴",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 2,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "하체",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 3,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "등",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 4,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "어깨",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize14(),
                  child: Text(
                    "운동시간 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 0,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "30분 이하",
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 1,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "1시간",
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 2,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "1시간 30분",
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "2시간 이상",
                ),
              ],
            ),
            g.vr03(),
            Center(
              child:_isLoading ? const Center(child: CircularProgressIndicator()) : GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoading = true; // 로딩 시작
                  });

                  String prompt = generateQuestion(_selectGoal, _selectGender, _selectDivide, _selectPart, _selectTime);
                  String response = await fetchGPTResponse(prompt);

                  setState(() {
                    answerPrint = prompt;
                    responsePrint = response;
                    _isLoading = false; // 로딩 종료
                  });
                },
                child: Container(
                  width: s.wrSize40(),
                  height: s.hrSize04(),
                  decoration: BoxDecoration(
                    color: custom_colors.besportsGreen,
                    borderRadius: BorderRadius.circular(s.hrSize03()),
                  ),
                  child: Center(
                    child: Text(
                      "운동 추천받기",
                      style: TextStyle(
                          fontSize: s.hrSize015(),
                          fontWeight: FontWeight.w700,
                          color: custom_colors.bgWhite),
                    ),
                  ),
                ),
              ),
            ),
            g.vr01(),
            Text(answerPrint),
            g.vr01(),
            Text(responsePrint)
          ],
        ),
      ),
    );
  }

  GestureDetector selectButton({
    required ValueNotifier<int> type,
    required int typeChoice,
    required double w,
    required double h,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (type.value == typeChoice) {
            type.value = -1;
          } else {
            type.value = typeChoice;
          }
        });
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: type.value == typeChoice
              ? custom_colors.besportsGreen
              : custom_colors.consumeLightGreen,
          borderRadius: BorderRadius.circular(s.hrSize007()),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: s.wrSize03(),
              fontWeight: FontWeight.w600,
              color: type.value == typeChoice
                  ? custom_colors.bgWhite
                  : custom_colors.black,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector selectMultipleButton({
    required ValueNotifier<List<int>> type,
    required int typeChoice,
    required double w,
    required double h,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (type.value.contains(typeChoice)) {
            type.value.remove(typeChoice);
          } else {
            type.value.add(typeChoice);
          }
          // type.notifyListeners();
        });
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: type.value.contains(typeChoice)
              ? custom_colors.besportsGreen
              : custom_colors.consumeLightGreen,
          borderRadius: BorderRadius.circular(s.hrSize007()),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: s.wrSize03(),
              fontWeight: FontWeight.w600,
              color: type.value.contains(typeChoice)
                  ? custom_colors.bgWhite
                  : custom_colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
