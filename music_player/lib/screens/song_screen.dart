import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_bloc.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_event.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_state.dart';
import 'package:music_player/constant/colors.dart';
import 'package:music_player/widgets/box_decoration.dart';
import 'package:music_player/widgets/query_art_work.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SongScreen extends StatefulWidget {
  SongScreen(
      {super.key,
      required this.songModel,
      required this.player,
      required this.isSongPlaying,
      required this.currentIndex});
  List<SongModel> songModel;
  AudioPlayer player;
  bool isSongPlaying;
  int currentIndex;
  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  List<SongModel>? songModel;
  AudioPlayer? player;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool? isSongPlaying;
  int? currentIndex;

  @override
  void initState() {
    songModel = widget.songModel;
    player = widget.player;
    isSongPlaying = widget.isSongPlaying;
    currentIndex = widget.currentIndex;
    super.initState();
    listenToMusic();
  }

  void listenToMusic() {
    player!.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
    try {
      player!.durationStream.listen((d) {
        if (mounted) {
          setState(() {
            duration = d!;
          });
        }
      });
      player!.positionStream.listen((p) {
        if (mounted) {
          setState(() {
            position = p;
          });
        }
      });
      isSongPlaying = true;
    } catch (e) {
      print('object');
    }
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songModel!.isNotEmpty) {
        currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroundColor,
      body: SafeArea(child: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image(
                              height: 5.w,
                              width: 5.w,
                              image: AssetImage('images/back_icon.png'))),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: MyBoxDecoration(
                          innerPadding: 10, imageUrl: 'images/favour.png'),
                    )
                  ],
                ),
              ),
              if (state is SongsChangeSongState) ...{
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 50.h,
                        image: AssetImage('images/poster_background.png')),
                    MyQueryArtWork(
                        borderRadius: BorderRadius.circular(10),
                        size: 85,
                        artWorkType: ArtworkType.AUDIO,
                        id: state.songModel[currentIndex!].id)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    width: 80.w,
                    child: Text(
                      state.songModel[currentIndex!].displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    width: 80.w,
                    child: Text(
                      state.songModel[currentIndex!].artist!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20.sp, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                      color: Color(0xff242629),
                      borderRadius: BorderRadius.circular(7.5),
                      boxShadow: [
                        BoxShadow(
                            blurStyle: BlurStyle.inner,
                            offset: Offset(2, 2),
                            color: Color(0xff000000).withOpacity(0.33),
                            blurRadius: 4),
                        BoxShadow(
                            blurStyle: BlurStyle.inner,
                            offset: Offset(-3, -3),
                            color: Color(0xffFFFFFF).withOpacity(0.10),
                            blurRadius: 4)
                      ]),
                  child: SliderTheme(
                    data: SliderThemeData(
                        inactiveTrackColor: Colors.transparent,
                        activeTrackColor: Color(0xffFE553F),
                        overlayShape: SliderComponentShape.noOverlay),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Slider(
                        thumbColor: Color(0xffFE553F),
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            SliderValue(value.toInt());
                            value = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        formatDuration(position),
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                      Spacer(),
                      Text(
                        formatDuration(Duration(
                            milliseconds: songModel![currentIndex!].duration!)),
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await player!.setShuffleModeEnabled(true);
                        },
                        child: Image(
                            height: 7.w,
                            width: 7.w,
                            image: AssetImage('images/shuffle.png')),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            if (player!.hasPrevious) {
                              await player!.seekToPrevious();
                            }
                          } catch (e) {}

                          if (currentIndex != null) {
                            setState(() {
                              if (player!.hasPrevious) {
                                currentIndex! - 1;
                              }
                            });
                          }
                          // context.read<SongsBloc>().add(
                          //     SongsChangeSongEvent(currentIndex!, songModel!));
                        },
                        child: MyBoxDecoration(
                            innerPadding: 12, imageUrl: 'images/pervious.png'),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (isSongPlaying!) {
                              player!.stop();
                            } else {
                              player!.play();
                            }
                            isSongPlaying = !isSongPlaying!;
                          },
                          child: MyBoxDecoration(
                              innerPadding: 32, imageUrl: 'images/stop.png')),
                      GestureDetector(
                          onTap: () async {
                            try {
                              if (player!.hasNext) {
                                await player!.seekToNext();
                              }
                            } catch (e) {}

                            if (currentIndex != null) {
                              setState(() {
                                if (player!.hasNext) {
                                  currentIndex! + 1;
                                }
                              });
                            }
                            // context.read<SongsBloc>().add(SongsChangeSongEvent(
                            //     currentIndex!, songModel!));
                          },
                          child: MyBoxDecoration(
                              innerPadding: 12, imageUrl: 'images/next.png')),
                      Image(
                          height: 7.w,
                          width: 7.w,
                          image: AssetImage('images/volume.png'))
                    ],
                  ),
                )
              }
            ],
          );
        },
      )),
    );
  }

  void SliderValue(int seconds) {
    Duration duration = Duration(seconds: seconds);
    player!.seek(duration);
  }
}

String formatDuration(Duration duration) {
  String hours = duration.inHours.toString().padLeft(0, '2');
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours == '0') {
    return "$minutes:$seconds";
  } else {
    return "$hours:$minutes:$seconds";
  }
}
