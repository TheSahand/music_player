import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class SongsState {}

class SongsInitState extends SongsState {}

class SongsChangeSongState extends SongsState {
  int index;
  List<SongModel> songModel;
  // final String songName;
  // final String artistName;
  // final int imageUrlId;

  SongsChangeSongState(this.index, this.songModel);
}
