import 'dart:collection';

class BoolStatus {
  static bool isModal = false;
  static bool isModalOpen = false;
}

class ExerciseStatus {
  static SplayTreeMap<String, List<Map<String, int>>> result =
      SplayTreeMap<String, List<Map<String, int>>>();
}
