import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class HomeEvent {}

class HomeChangeSongEvent extends HomeEvent {
  int index;
  List<SongModel> songModel;
  AudioPlayer audioPlayer;
  HomeChangeSongEvent(this.index, this.songModel, this.audioPlayer);
}
