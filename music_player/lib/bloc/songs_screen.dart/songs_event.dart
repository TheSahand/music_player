import 'package:on_audio_query/on_audio_query.dart';

abstract class SongsEvent {}

class SongsChangeSongEvent extends SongsEvent {
  int index;
  List<SongModel> songModel;
  // final String songName;
  // final String artistName;
  // final int imageUrlId;
  SongsChangeSongEvent(this.index, this.songModel);
}
