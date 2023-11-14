import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyQueryArtWork extends StatelessWidget {
  MyQueryArtWork({
    super.key,
    required this.size,
    required this.artWorkType,
    required this.id,
    required this.borderRadius,
  });
  int id;
  double size;
  ArtworkType artWorkType;
  BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
        artworkBorder: borderRadius,
        artworkWidth: size.w,
        artworkHeight: size.w,
        keepOldArtwork: true,
        nullArtworkWidget: Image(
            height: size.w,
            width: size.w,
            fit: BoxFit.cover,
            image: AssetImage('images/null_pic.png')),
        id: id,
        type: artWorkType);
  }
}
