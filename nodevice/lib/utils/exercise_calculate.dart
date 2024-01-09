import 'package:nodevice/data_struct/set_data.dart';

double getOneRM(SetData setData) {
  return setData.weight / (1.0278 - (0.0278 * setData.reps));
}

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) {
    return 0.0; // 또는 적절한 오류 처리
  }

  double sum = numbers.fold(0.0, (previous, current) => previous + current);
  return sum / numbers.length;
}
