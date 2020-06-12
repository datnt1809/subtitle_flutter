import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysubtitle/data/movie_repository.dart';
import 'package:mysubtitle/data/response/api_models.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

// ignore: must_be_immutable
class MovieFetchEvent extends MovieEvent {
  int page;

  MovieFetchEvent(int page) {
    this.page = page;
  }

  @override
  // TODO: implement props
  List<Object> get props => [page];
}

class MovieDetailEvent extends MovieEvent {
  final String movieId;

  const MovieDetailEvent({@required this.movieId}) : assert(movieId != null);

  @override
  // TODO: implement props
  List<Object> get props => [movieId];
}

abstract class MovieFetchState extends Equatable {
  const MovieFetchState();

  @override
  List<Object> get props => [];
}

class MovieUninitializedState extends MovieFetchState {}

class MovieFetchedState extends MovieFetchState {
  final List<Movie> movies;
  final int page;
  final bool hasReachedMax;

  const MovieFetchedState({this.movies, this.page, this.hasReachedMax});

  MovieFetchedState copyWith(
      {List<Movie> posts, int page, bool hasReachedMax}) {
    return MovieFetchedState(
        movies: posts ?? this.movies,
        page: page ?? this.page,
        hasReachedMax: hasReachedMax);
  }

  @override
  List<Object> get props => [movies];
}

class MovieErrorState extends MovieFetchState {}

class MovieEmptyState extends MovieFetchState {}

class MovieBloc extends Bloc<MovieEvent, MovieFetchState> {
  MovieRepository movieRepository = MovieRepository.instance;
  MovieFetchedState fetchedState;

  @override
  // TODO: implement initialState
  MovieFetchState get initialState => MovieEmptyState();

  @override
  Stream<MovieFetchState> mapEventToState(MovieEvent event) async* {
    if (event is MovieFetchEvent) {
      yield* _mapFetchMovieToState(event);
    }
  }

  Stream<MovieFetchState> _mapFetchMovieToState(MovieFetchEvent event) async* {
    final currentState = state;
    try {
      if (currentState is MovieEmptyState) {
        List<Movie> listMovie = await movieRepository.fetchMovie(1);
        yield MovieFetchedState(
            movies: listMovie, page: 2, hasReachedMax: false);
      } else if (currentState is MovieFetchedState) {
        List<Movie> listMovie = await movieRepository.fetchMovie(currentState.page);
        yield listMovie.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : MovieFetchedState(
                movies: currentState.movies + listMovie ,
                page: currentState.page + 1,
                hasReachedMax: false);
      }
    } catch (_) {
      yield MovieErrorState();
    }
  }

}
