import 'package:bloc/bloc.dart';
import 'package:music_player/bloc/home_screen/home_event.dart';
import 'package:music_player/bloc/home_screen/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitState()) {
    on<HomeChangeSongEvent>((event, emit) {
      emit(
          HomeChangeSongState(event.index, event.songModel, event.audioPlayer));
    });
  }
}
