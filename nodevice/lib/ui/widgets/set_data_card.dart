import 'package:flutter/material.dart';

class SetDataCard extends StatelessWidget {
  final int setNumber;
  final int weight;
  final int reps;

  const SetDataCard({
    super.key,
    required this.setNumber,
    required this.weight,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          '세트 $setNumber',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF9F7BFF),
          ),
        ),
        subtitle: Text('무게: $weight kg, 횟수: $reps 회'),
      ),
    );
  }
}
