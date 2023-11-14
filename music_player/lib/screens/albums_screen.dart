import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumsScreen extends StatefulWidget {
  AlbumsScreen({
    super.key,
    required this.albumModel,
  });
  AlbumModel albumModel;
  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.albumModel.numOfSongs,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(5),
              height: 100,
              width: 100,
              child: Text('${widget.albumModel.artist}'),
            );
          },
        ),
      ),
    );
  }
}
