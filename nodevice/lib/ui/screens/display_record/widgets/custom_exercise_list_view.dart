import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nodevice/constants/custom_colors.dart';

class ExerciseListView extends StatefulWidget {
  const ExerciseListView(
      {Key? key, required this.category, required this.searchQuery})
      : super(key: key);
  final String category;
  final String searchQuery;

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  final databaseRef = FirebaseDatabase.instance.ref(); // Firebase 데이터베이스 참조 생성

  Future<List<String>> getExercises() async {
    List<String> exercises = [];
    try {
      DataSnapshot snapshot;

      if (widget.category == 'all') {
        // 'all'일 때 'exercises' 아래의 모든 데이터를 가져옵니다.
        snapshot = await databaseRef.child('exercises').get();

        if (snapshot.exists) {
          final value = snapshot.value;
          if (value is Map) {
            value.forEach((categoryKey, categoryValue) {
              if (categoryValue is Map) {
                categoryValue.forEach((exerciseKey, exerciseValue) {
                  exercises.add(exerciseValue.toString());
                });
              } else if (categoryValue is List) {
                for (var exerciseValue in categoryValue) {
                  if (exerciseValue != null) {
                    exercises.add(exerciseValue.toString());
                  }
                }
              }
            });
          }
        }
      } else {
        // 'all'이 아닐 때는 특정 카테고리의 운동만 가져옵니다.
        snapshot =
            await databaseRef.child('exercises/${widget.category}').get();

        if (snapshot.exists) {
          final value = snapshot.value;
          if (value is Map) {
            value.forEach((exerciseKey, exerciseValue) {
              exercises.add(exerciseValue.toString());
            });
          } else if (value is List) {
            for (var exerciseValue in value) {
              if (exerciseValue != null) {
                exercises.add(exerciseValue.toString());
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching exercises: $e');
    }
    if (widget.searchQuery.isNotEmpty) {
      exercises = exercises
          .where((exercise) =>
              exercise.toLowerCase().contains(widget.searchQuery.toLowerCase()))
          .toList();
    }
    return exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appDarkBackColor,
      body: FutureBuilder<List<String>>(
        future: getExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // 데이터가 준비되면, ListView.builder를 사용하여 표시
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.fitness_center,
                      color: Theme.of(context).canvasColor),
                  title: Text(snapshot.data![index],
                      style: TextStyle(color: Theme.of(context).canvasColor)),
                );
              },
            );
          }
        },
      ),
    );
  }
}
