import 'package:hive_flutter/hive_flutter.dart';
part 'play_list.g.dart';

@HiveType(typeId: 2)
class PlayList {
  @HiveField(3)
  String playListName;
  PlayList(this.playListName);
}
