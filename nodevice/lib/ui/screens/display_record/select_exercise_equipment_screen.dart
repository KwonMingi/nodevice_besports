import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/ui/screens/display_record/widgets/custom_exercise_list_view.dart'; // CustomColors 클래스를 import

class SelectExerciseEquipmentScreenState extends StatefulWidget {
  const SelectExerciseEquipmentScreenState({super.key});

  @override
  State<SelectExerciseEquipmentScreenState> createState() =>
      _SelectExerciseEquipmentScreenStateState();
}

class _SelectExerciseEquipmentScreenStateState
    extends State<SelectExerciseEquipmentScreenState> {
  int? selectedButtonIndex = 0; // 선택된 버튼의 인덱스를 저장하는 변수
  TextEditingController searchController =
      TextEditingController(); // 검색 컨트롤러 추가

  @override
  Widget build(BuildContext context) {
    List<String> exerciseTargetName = [
      '전체',
      '등',
      '이두',
      '유산소',
      '가슴',
      '코어',
      '전완',
      '하체',
      '어깨',
      '삼두',
      '스포츠',
    ];
    List<String> exerciseTargetEnName = [
      'all',
      'back',
      'biceps',
      'cardio',
      'chest',
      'core',
      'forearm',
      'lowerBody',
      'shoulder',
      'triceps',
      'sports',
    ];

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
        body: SingleChildScrollView(
          // SingleChildScrollView 추가
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
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
                            controller: searchController, // 검색 컨트롤러
                            decoration: InputDecoration(
                              hintText: '운동을 검색해보세요!',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).canvasColor,
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          searchController
                                              .clear(); // 텍스트 필드 내용을 지웁니다.
                                        });
                                      },
                                      child: Icon(
                                        Icons.close, // 'X' 아이콘
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    )
                                  : null, // 텍스트 필드가 비어있으면 'X' 아이콘을 표시하지 않습니다.
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                  color: Theme.of(context).canvasColor),
                            ),
                            style:
                                TextStyle(color: Theme.of(context).canvasColor),
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) {
                              setState(() {}); // 텍스트가 변경될 때마다 UI를 갱신합니다.
                            },
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
                          itemCount: exerciseTargetName.length +
                              1, // 즐겨찾기 버튼 포함하여 항목 수 계산
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
                                        : CustomColors
                                            .boxGray, // 선택되지 않은 버튼은 회색으로
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(30, 36)),
                                  maximumSize: MaterialStateProperty.all(
                                      const Size(80, 36)),
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
                  child: selectedButtonIndex == 0
                      ? Container(
                          color: CustomColors
                              .appGray, // 초기 화면 또는 즐겨찾기 화면 등을 여기에 구현
                          child: const Center(
                              child: Text("즐겨찾기 또는 기본 화면을 여기에 구현")),
                        )
                      : ExerciseListView(
                          category:
                              exerciseTargetEnName[selectedButtonIndex! - 1],
                          searchQuery: searchController.text, // 검색 쿼리 전달
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose(); // 컨트롤러 해제
    super.dispose();
  }
}
