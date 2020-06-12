import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysubtitle/data/movie_repository.dart';
import 'package:mysubtitle/data/response/api_subtitle.dart';

abstract class SubtitleEvent extends Equatable {
  const SubtitleEvent();
}

// ignore: must_be_immutable
class SubtitleFetchEvent extends SubtitleEvent {
  final movieId;
  SubtitleFetchEvent({@required this.movieId});
  @override
  // TODO: implement props
  List<Object> get props => [movieId];
}

class SubtitleFilterEvent extends SubtitleEvent {
  final language;
  SubtitleFilterEvent({@required this.language});
  @override
  // TODO: implement props
  List<Object> get props => [language];
}


abstract class SubtitleFetchState extends Equatable {
  const SubtitleFetchState();

  @override
  List<Object> get props => [];
}

class SubtitleUninitializedState extends SubtitleFetchState {}

class SubtitleFetchedState extends SubtitleFetchState {
  final List<Subtitle> subtitles;
  final List<String> language;
  final bool hasReachedMax;

  const SubtitleFetchedState({this.subtitles,this.language, this.hasReachedMax});

  SubtitleFetchedState copyWith(
      {List<Subtitle> posts, int page, bool hasReachedMax}) {
    return SubtitleFetchedState(
        subtitles: posts ?? this.subtitles,
        hasReachedMax: hasReachedMax);
  }

  @override
  List<Object> get props => [subtitles];
}

class SubtitleFilterState extends SubtitleFetchState {
  final List<Subtitle> subtitles;
  final List<Subtitle> originalSubtitles;
  const SubtitleFilterState({this.subtitles, this.originalSubtitles});

  SubtitleFilterState copyWith(
      {List<Subtitle> subtitles, List<Subtitle> originalSubtitles}) {
    return SubtitleFilterState(subtitles: subtitles ?? this.subtitles, originalSubtitles: originalSubtitles ?? this.originalSubtitles);
  }

  @override
  List<Object> get props => [subtitles];
}

class SubtitleErrorState extends SubtitleFetchState {}

class SubtitleEmptyState extends SubtitleFetchState {}

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleFetchState> {
  final MovieRepository movieRepository;
  SubtitleFetchedState fetchedState;

  SubtitleBloc({@required this.movieRepository}) : assert(movieRepository != null);

  @override
  // TODO: implement initialState
  SubtitleFetchState get initialState => SubtitleEmptyState();

  @override
  Stream<SubtitleFetchState> mapEventToState(SubtitleEvent event) async* {
    if (event is SubtitleFilterEvent){
      yield* _filterSubtitleToState(event);
    }else if (event is SubtitleFetchEvent)
      yield* _mapFetchSubtitleToState(event);
  }

  Stream<SubtitleFetchState>  _filterSubtitleToState(SubtitleFilterEvent event)  async*{
    if (state is SubtitleFetchedState){
      final SubtitleFetchedState fetchedState = state as SubtitleFetchedState;
      List<Subtitle> subtitles = await filterSubtitle( event.language, fetchedState.subtitles);
      yield SubtitleFilterState(subtitles: subtitles, originalSubtitles: fetchedState.subtitles);
    }else if (state is SubtitleFilterState){
      final SubtitleFilterState filterState = state as SubtitleFilterState;
      List<Subtitle> subtitles = await filterSubtitle( event.language, filterState.originalSubtitles);
      yield SubtitleFilterState(subtitles: subtitles, originalSubtitles: filterState.originalSubtitles);
    }

  }

  Stream<SubtitleFetchState> _mapFetchSubtitleToState(SubtitleFetchEvent event) async* {
    try {
      List<Subtitle> listSubtitle = await movieRepository.fetchSubtitle(event.movieId);
      List<String> language = await filterDifferentLanguages(listSubtitle);

    yield SubtitleFetchedState(subtitles: listSubtitle,language: language, hasReachedMax: false);
    } catch (_) {
      yield SubtitleErrorState();
    }
  }
  Future<List<String>> filterDifferentLanguages(List<Subtitle> subtitles) async {
    List<String> language = new List<String>();
    for (var i = 0 ; i <  subtitles.length; i++){
      bool existed = false;
      for (var j = i-1; j >=0; j--){
        if (subtitles[i].languageId == subtitles[j].languageId){
          existed = true;
          break;
        }
      }
      if (!existed)
        language.add(subtitles[i].language);
    }
    return language;
  }

  Future<List<Subtitle>> filterSubtitle(String language, List<Subtitle> subtitles) async {
    List<Subtitle> filterSubtitles = new List<Subtitle>();
    subtitles.forEach((element) {
      if (element.language == language)
        filterSubtitles.add(element);
    });
    return filterSubtitles;
  }

}
