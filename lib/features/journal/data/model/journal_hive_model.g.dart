// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalHiveModelAdapter extends TypeAdapter<JournalHiveModel> {
  @override
  final int typeId = 2;

  @override
  JournalHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalHiveModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      trekId: fields[2] as String,
      date: fields[3] as String,
      text: fields[4] as String,
      photos: (fields[5] as List).cast<String>(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JournalHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.trekId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.photos)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
