// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataFetcher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataItemAdapter extends TypeAdapter<DataItem> {
  @override
  final int typeId = 1;

  @override
  DataItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataItem(
      startTime: fields[0] as DateTime,
      value: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DataItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
