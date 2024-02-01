import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nodevice/constants/custom_colors.dart'; // CustomColors 클래스를 import

class SelectExerciseEquipmentScreenState extends StatefulWidget {
  const SelectExerciseEquipmentScreenState({super.key});

  @override
  State<SelectExerciseEquipmentScreenState> createState() =>
      _SelectExerciseEquipmentScreenStateState();
}

class _SelectExerciseEquipmentScreenStateState
    extends State<SelectExerciseEquipmentScreenState> {
  int? selectedButtonIndex = 0; // 선택된 버튼의 인덱스를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    List<String> exerciseTargetName = ['어깨', '팔', '등', '가슴', '코어', '하체'];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: CustomColors.appDarkBackColor, // 상단 상태 바 색상 설정
        systemNavigationBarColor:
            CustomColors.appDarkBackColor, // 하단 네비게이션 바 색상 설정
        statusBarIconBrightness:
            Brightness.light, // 상태 바 아이콘 밝기 설정 (어두운 색상의 배경에 맞게 밝게)
        systemNavigationBarIconBrightness:
            Brightness.light, // 네비게이션 바 아이콘 밝기 설정 (어두운 색상의 배경에 맞게 밝게)
      ),
      child: Scaffold(
        backgroundColor: CustomColors.appDarkBackColor,
        body: Column(
          children: [
            Flexible(
              flex: 25,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '운동 검색',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 200, // 최소 너비
                        maxWidth: MediaQuery.of(context).size.width *
                            0.9, // 최대 너비를 화면 너비의 90%로 설정
                        minHeight: 40, // 최소 높이
                        maxHeight: 80, // 최대 높이
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.boxGray, // 배경색 설정
                        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '운동을 검색해보세요!',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context)
                                .canvasColor, // 돋보기 아이콘과 텍스트 색상 설정
                          ),
                          border: InputBorder.none, // 테두리 삭제
                          contentPadding: const EdgeInsets.all(10), // 내부 패딩 조정
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).canvasColor, // 힌트 텍스트 색상 설정
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).canvasColor, // 입력 텍스트 색상 설정
                        ),
                        textAlignVertical:
                            TextAlignVertical.center, // 텍스트를 수직 방향으로 중앙에 위치
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 36, // 버튼의 높이 설정
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // 수평 스크롤 활성화
                      itemCount:
                          exerciseTargetName.length + 1, // 즐겨찾기 버튼 포함하여 항목 수 계산
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4), // 버튼 간 간격 조정
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedButtonIndex = index;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (_) => selectedButtonIndex == index
                                    ? CustomColors.appGreen // 선택된 버튼은 초록색으로
                                    : CustomColors.boxGray, // 선택되지 않은 버튼은 회색으로
                              ),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(30, 36)),
                              maximumSize:
                                  MaterialStateProperty.all(const Size(80, 36)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: index == 0
                                ? Icon(
                                    Icons.star_border,
                                    color: selectedButtonIndex == index
                                        ? CustomColors
                                            .appDarkColor // 선택된 경우 아이콘 색상 변경
                                        : Theme.of(context)
                                            .canvasColor, // 선택되지 않은 경우 원래 색상 유지
                                  )
                                : Text(
                                    exerciseTargetName[index - 1],
                                    style: TextStyle(
                                      color: selectedButtonIndex == index
                                          ? CustomColors
                                              .appDarkColor // 선택된 경우 텍스트 색상 변경
                                          : Theme.of(context)
                                              .canvasColor, // 선택되지 않은 경우 원래 색상 유지
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 75,
              child: Container(
                color: CustomColors.appGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
