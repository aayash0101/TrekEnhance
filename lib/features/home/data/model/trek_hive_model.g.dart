// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trek_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrekHiveModelAdapter extends TypeAdapter<TrekHiveModel> {
  @override
  final int typeId = 1;

  @override
  TrekHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrekHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      location: fields[2] as String,
      smallDescription: fields[3] as String,
      description: fields[4] as String,
      difficulty: fields[5] as String,
      distance: fields[6] as double,
      bestSeason: fields[7] as String,
      imageUrl: fields[8] as String,
      highlights: (fields[9] as List).cast<String>(),
      reviews: (fields[10] as List).cast<ReviewHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TrekHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.smallDescription)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.distance)
      ..writeByte(7)
      ..write(obj.bestSeason)
      ..writeByte(8)
      ..write(obj.imageUrl)
      ..writeByte(9)
      ..write(obj.highlights)
      ..writeByte(10)
      ..write(obj.reviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrekHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
