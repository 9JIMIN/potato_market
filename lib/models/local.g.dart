// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAdapter extends TypeAdapter<Local> {
  @override
  final int typeId = 1;

  @override
  Local read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Local(
      uid: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      imageUrl: fields[3] as String,
      phoneNumber: fields[4] as String,
      place: (fields[5] as Map)?.cast<String, dynamic>(),
      productCategories: (fields[6] as Map)?.cast<String, bool>(),
      postCategories: (fields[7] as Map)?.cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, Local obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.place)
      ..writeByte(6)
      ..write(obj.productCategories)
      ..writeByte(7)
      ..write(obj.postCategories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
