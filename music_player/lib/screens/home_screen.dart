import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/bloc/home_screen/home_bloc.dart';
import 'package:music_player/bloc/home_screen/home_event.dart';
import 'package:music_player/bloc/home_screen/home_state.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_bloc.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_event.dart';
import 'package:music_player/constant/colors.dart';
import 'package:music_player/screens/albums_screen.dart';
import 'package:music_player/screens/song_screen.dart';
import 'package:music_player/widgets/query_art_work.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController controller = ScrollController();
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  List<SongModel> songs = [];
  int currentIndex = 0;
  bool isSongPlaying = false;
  bool showFloatingContainer = false;
  List<SongModel> recentlyPLayed = [];

  @override
  void initState() {
    requestPermisssion();
    super.initState();
    player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  void requestPermisssion() async {
    await Permission.storage.request();
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
      if (permissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: MyColor.backgroundColor,
        body: SafeArea(
          child: Stack(alignment: Alignment.bottomCenter, children: [
            CustomScrollView(
              controller: controller,
              slivers: [
                const BackIcon(),
                const _LibraryTitle(),
                SliverPadding(padding: EdgeInsets.only(top: 4.h)),
                const _RecentlyTitle(),
                SliverPadding(padding: EdgeInsets.only(top: 1.h)),
                _RecentlyList(
                  recentlyPlayed: recentlyPLayed,
                  currentIndex: currentIndex,
                ),
                SliverPadding(padding: EdgeInsets.only(top: 3.h)),
                const _AppBar(),
                SliverPadding(padding: EdgeInsets.only(top: 3.h)),
                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      FutureBuilder<List<SongModel>>(
                        future: audioQuery.querySongs(
                            sortType: SongSortType.DISPLAY_NAME,
                            orderType: OrderType.DESC_OR_GREATER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                              'No songs found',
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            ));
                          }
                          songs = snapshot.data!;
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            controller: controller,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  recentlyPLayed.add(snapshot.data![index]);
                                  BlocProvider.of<HomeBloc>(context).add(
                                      HomeChangeSongEvent(
                                          index, snapshot.data!, player));

                                  playSong(snapshot.data![index].uri, index,
                                      snapshot.data!);
                                  showFloatingContainer = true;
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, bottom: 10, top: 10),
                                  height: 18.w,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyQueryArtWork(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          id: snapshot.data![index].id,
                                          size: 20,
                                          artWorkType: ArtworkType.AUDIO),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 60.w,
                                            child: Text(
                                              snapshot.data![index].artist!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60.w,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white),
                                              textAlign: TextAlign.left,
                                              snapshot.data![index].displayName,
                                            ),
                                          ),
                                          Text(
                                            formatDuration(Duration(
                                                milliseconds: snapshot
                                                    .data![index].duration!)),
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Image(
                                              width: 5.w,
                                              height: 5.w,
                                              image: AssetImage(
                                                  'images/more.png')))
                                    ],
                                  ),
                                ),
                              );
                            },
                            padding: EdgeInsets.only(bottom: 16.h),
                          );
                        },
                      ),
                      Container(
                        color: Color(0xff1F1F28),
                      ),
                      Container(
                        child: FutureBuilder<List<AlbumModel>>(
                            future: audioQuery.queryAlbums(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.white),
                                  ),
                                );
                              }
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text(
                                  'No songs found',
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.white),
                                ));
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                controller: controller,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AlbumsScreen(
                                              albumModel: snapshot.data![index],
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          MyQueryArtWork(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              id: snapshot.data![index].id,
                                              size: 20,
                                              artWorkType: ArtworkType.ALBUM),
                                          Text(
                                            snapshot.data![index].artist!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                      Container(
                        color: Color(0xff1F1F28),
                      )
                    ],
                  ),
                ),
              ],
            ),
            _floatingContainer(
              showFloatingContainer: showFloatingContainer,
              isSongPlaying: isSongPlaying,
              player: player,
              currentIndex: currentIndex,
            )
          ]),
        ),
      ),
    );
  }

  void playSong(String? uri, int index, List<SongModel> songModel) {
    try {
      player.setAudioSource(craetePlayList(songModel), initialIndex: index);
      player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ConcatenatingAudioSource craetePlayList(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentIndex = index;
      }
    });
  }
}

class _floatingContainer extends StatelessWidget {
  _floatingContainer({
    super.key,
    required this.showFloatingContainer,
    required this.player,
    required this.isSongPlaying,
    required this.currentIndex,
    // required this.songModel,
  });
  bool showFloatingContainer;
  AudioPlayer player;
  bool isSongPlaying;
  int currentIndex;
  // SongModel songModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Visibility(
          visible: showFloatingContainer,
          child: GestureDetector(
            onTap: () {
              if (state is HomeChangeSongState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) {
                                var bloc = SongsBloc();
                                bloc.add(SongsChangeSongEvent(
                                    currentIndex, state.songModel));
                                return bloc;
                              },
                              child: SongScreen(
                                songModel: state.songModel,
                                player: player,
                                isSongPlaying: isSongPlaying,
                                currentIndex: currentIndex,
                              ),
                            )));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.white10,
                    height: 11.h,
                    child: Row(
                      children: [
                        if (state is HomeChangeSongState) ...{
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: MyQueryArtWork(
                                borderRadius: BorderRadius.circular(5),
                                size: 20,
                                artWorkType: ArtworkType.AUDIO,
                                id: state.songModel[currentIndex].id),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 65.w,
                                child: TextScroll(
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(50, 0)),
                                  pauseBetween: const Duration(seconds: 2),
                                  state.songModel[currentIndex].artist!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17.sp),
                                ),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              SizedBox(
                                width: 65.w,
                                child: TextScroll(
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(50, 0)),
                                  pauseBetween: const Duration(seconds: 2),
                                  state.songModel[currentIndex].displayName,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17.sp),
                                ),
                              )
                            ],
                          )
                        }
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: SliverOverlapAbsorberHandle(),
      sliver: SliverSafeArea(
        sliver: SliverAppBar(
          elevation: 0,
          primary: false,
          floating: true,
          snap: true,
          backgroundColor: Color(0xff1F1F28),
          toolbarHeight: 1.h,
          pinned: true,
          bottom: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 17.sp),
              labelColor: Color(0xffFE553F),
              unselectedLabelColor: Colors.white,
              indicatorColor: Color(0xffFE553F),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(
                  text: 'Songs',
                ),
                Tab(
                  text: 'PlayLists',
                ),
                Tab(
                  text: 'Albums',
                ),
                Tab(
                  text: 'Artists',
                )
              ]),
        ),
      ),
    );
  }
}

class _RecentlyList extends StatelessWidget {
  _RecentlyList({
    super.key,
    required this.recentlyPlayed,
    required this.currentIndex,
  });
  List<SongModel> recentlyPlayed;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 18.h,
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: recentlyPlayed.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                height: 50.w,
                width: 50.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      MyQueryArtWork(
                          size: 100,
                          artWorkType: ArtworkType.AUDIO,
                          id: recentlyPlayed[index].id,
                          borderRadius: BorderRadius.circular(5)),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            height: 7.h,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  recentlyPlayed[index].displayName,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.sp),
                                ),
                                Text(
                                  recentlyPlayed[index].artist!,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.sp),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecentlyTitle extends StatelessWidget {
  const _RecentlyTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          'Recently played',
          style: TextStyle(fontSize: 17.sp, color: Colors.white),
        ),
      ),
    );
  }
}

class _LibraryTitle extends StatelessWidget {
  const _LibraryTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
          child: Text(
        'Library',
        style: TextStyle(fontSize: 27.sp, color: Colors.white),
      )),
    );
  }
}

class BackIcon extends StatelessWidget {
  const BackIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: IconButton(
                onPressed: () {},
                icon: Image(
                  height: 5.w,
                  width: 5.w,
                  image: AssetImage('images/back_icon.png'),
                )),
          ),
        ],
      ),
    );
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
