// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetAdapter extends TypeAdapter<Pet> {
  @override
  final int typeId = 0;

  @override
  Pet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pet(
      id: fields[0] as String,
      name: fields[1] as String,
      breed: fields[2] as String,
      age: fields[3] as int,
      gender: fields[4] as String,
      size: fields[5] as String,
      color: fields[6] as String,
      description: fields[7] as String,
      images: (fields[8] as List).cast<String>(),
      location: fields[9] as String,
      isAdopted: fields[10] as bool,
      contactEmail: fields[11] as String?,
      contactPhone: fields[12] as String?,
      createdAt: fields[13] as DateTime?,
      cost: fields[14] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Pet obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.breed)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.images)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.isAdopted)
      ..writeByte(11)
      ..write(obj.contactEmail)
      ..writeByte(12)
      ..write(obj.contactPhone)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.cost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      location: json['location'] as String,
      isAdopted: json['isAdopted'] as bool? ?? false,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      cost: (json['cost'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'breed': instance.breed,
      'age': instance.age,
      'gender': instance.gender,
      'size': instance.size,
      'color': instance.color,
      'description': instance.description,
      'images': instance.images,
      'location': instance.location,
      'isAdopted': instance.isAdopted,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'createdAt': instance.createdAt?.toIso8601String(),
      'cost': instance.cost,
    };
