// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_recently_songs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlySongsAdapter extends TypeAdapter<RecentlySongs> {
  @override
  final int typeId = 0;

  @override
  RecentlySongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlySongs(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlySongs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.songName)
      ..writeByte(1)
      ..write(obj.artistName)
      ..writeByte(2)
      ..write(obj.imageUrlId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlySongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
