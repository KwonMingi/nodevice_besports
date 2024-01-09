// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../set_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetDataAdapter extends TypeAdapter<SetData> {
  @override
  final int typeId = 2;

  @override
  SetData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetData(
      fields[0] as double, // weight
      fields[1] as int, // reps
    ).._time = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, SetData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._weight)
      ..writeByte(1)
      ..write(obj._reps)
      ..writeByte(2)
      ..write(obj._time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
