import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/bloc/home_screen/home_bloc.dart';
import 'package:music_player/models/play_list.dart';
import 'package:music_player/models/save_recently_songs.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecentlySongsAdapter());
  Hive.registerAdapter(PlayListAdapter());
  await Hive.openBox<RecentlySongs>('SongsBox');
  await Hive.openBox<PlayList>('PlayListBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocProvider(
            create: (context) => HomeBloc(),
            child: HomeScreen(),
          ),
        );
      },
    );
  }
}
