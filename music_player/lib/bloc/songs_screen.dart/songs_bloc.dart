import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_event.dart';
import 'package:music_player/bloc/songs_screen.dart/songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc() : super(SongsInitState()) {
    on<SongsChangeSongEvent>((event, emit) {
      emit(SongsChangeSongState(event.index, event.songModel));
    });
  }
}
