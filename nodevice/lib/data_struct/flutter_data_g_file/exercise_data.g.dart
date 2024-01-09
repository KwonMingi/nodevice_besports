// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../exercise_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Add default value for _restTime
    int restTime = fields[3] as int? ?? 0;

    // Pass both 'exerciseType' and 'restTime' to the Exercise constructor
    var exercise = Exercise(
      fields[1] as String,
      restTime,
    )
      .._date = fields[0] as String
      .._setDatas = (fields[2] as List).cast<SetData>();

    return exercise;
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(4) // Update number of fields
      ..writeByte(0)
      ..write(obj._date)
      ..writeByte(1)
      ..write(obj._exerciseType)
      ..writeByte(2)
      ..write(obj._setDatas)
      ..writeByte(3) // Write the _restTime field
      ..write(obj._restTime); // Add the _restTime field
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
