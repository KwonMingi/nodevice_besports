class RecordViewModel {
  int _currentSet = 0;
  final int _setCount;
  final String _exerciseType;
  final List<Map<String, int>> _setResults = [];

  int get currentSet => _currentSet;
  int get setCount => _setCount;
  String get exerciseType => _exerciseType;
  List<Map<String, int>> get setResults => _setResults;

  RecordViewModel({required int setCount, required String exerciseType})
      : _exerciseType = exerciseType,
        _setCount = setCount;

  void saveSetData(String weight, String reps) {
    if (_currentSet < _setCount) {
      int parsedWeight = int.tryParse(weight) ?? 0;
      int parsedReps = int.tryParse(reps) ?? 0;

      _setResults.add({'weight': parsedWeight, 'reps': parsedReps});
      _currentSet++;
      //_setResults.length;
    }
  }
}
