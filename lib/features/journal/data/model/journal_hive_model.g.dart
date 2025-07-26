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
      username: fields[2] as String,
      trekId: fields[3] as String,
      trekName: fields[4] as String,
      date: fields[5] as String,
      text: fields[6] as String,
      photos: (fields[7] as List).cast<String>(),
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JournalHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.trekId)
      ..writeByte(4)
      ..write(obj.trekName)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.text)
      ..writeByte(7)
      ..write(obj.photos)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
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
