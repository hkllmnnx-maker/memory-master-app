// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_item.dart';

class MemoryItemAdapter extends TypeAdapter<MemoryItem> {
  @override
  final int typeId = 0;

  @override
  MemoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return MemoryItem(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      category: fields[3] as String,
      createdAt: fields[4] as DateTime,
      nextReviewAt: fields[5] as DateTime,
      repetitionLevel: fields[6] as int? ?? 0,
      totalReviews: fields[7] as int? ?? 0,
      correctReviews: fields[8] as int? ?? 0,
      easeFactor: fields[9] as double? ?? 2.5,
      hints: (fields[10] as List?)?.cast<String>() ?? [],
      isFavorite: fields[11] as bool? ?? false,
      audioPath: fields[12] as String?,
      colorIndex: fields[13] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, MemoryItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.nextReviewAt)
      ..writeByte(6)
      ..write(obj.repetitionLevel)
      ..writeByte(7)
      ..write(obj.totalReviews)
      ..writeByte(8)
      ..write(obj.correctReviews)
      ..writeByte(9)
      ..write(obj.easeFactor)
      ..writeByte(10)
      ..write(obj.hints)
      ..writeByte(11)
      ..write(obj.isFavorite)
      ..writeByte(12)
      ..write(obj.audioPath)
      ..writeByte(13)
      ..write(obj.colorIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
