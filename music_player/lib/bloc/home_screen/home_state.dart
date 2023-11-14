import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeChangeSongState extends HomeState {
  int index;
  List<SongModel> songModel;
  AudioPlayer audioPlayer;
  HomeChangeSongState(this.index, this.songModel, this.audioPlayer);
}
