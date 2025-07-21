// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewHiveModelAdapter extends TypeAdapter<ReviewHiveModel> {
  @override
  final int typeId = 3;

  @override
  ReviewHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewHiveModel(
      trekId: fields[0] as String,
      userId: fields[1] as String,
      username: fields[2] as String,
      review: fields[3] as String,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.trekId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.review)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
