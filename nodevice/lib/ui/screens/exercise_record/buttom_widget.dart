import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';

class SetCountAdjustButtons extends StatelessWidget {
  final TextEditingController setCountController;
  final Function() updateParentState;
  final List<int> adjustments; // 사용자 정의 조정값 목록

  const SetCountAdjustButtons({
    Key? key,
    required this.setCountController,
    required this.updateParentState,
    this.adjustments = const [-5, -1, 1, 5], // 기본 조정값 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: adjustments.map((adjustment) {
        return _createAdjustButton(
          context: context,
          label:
              '${adjustment > 0 ? '+' : ''}$adjustment', // 조정값이 양수인 경우 '+' 기호 추가
          onPressed: () {
            _adjustSetCount(adjustment);
          },
        );
      }).toList(),
    );
  }

  Widget _createAdjustButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.appGreen,
      ),
      child: Text(
        label,
        style: const TextStyle(color: CustomColors.appDarkColor),
      ),
    );
  }

  void _adjustSetCount(int adjustment) {
    int currentSetCount = int.tryParse(setCountController.text) ?? 0;
    int newSetCount =
        (currentSetCount + adjustment).clamp(0, double.infinity).toInt();
    setCountController.text = newSetCount.toString();
    updateParentState();
  }
}
