import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
part 'save_recently_songs.g.dart';

@HiveType(typeId: 0)
class RecentlySongs extends HiveObject {
  @HiveField(0)
  String songName;
  @HiveField(1)
  String artistName;
  @HiveField(2)
  int imageUrlId;
  RecentlySongs(this.songName, this.artistName, this.imageUrlId);
}
