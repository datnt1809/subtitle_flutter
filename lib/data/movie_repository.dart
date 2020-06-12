import 'package:mysubtitle/data/player_api_provider.dart';
import 'package:mysubtitle/data/response/api_models.dart';
import 'package:mysubtitle/data/response/api_subtitle.dart';

class MovieRepository {

  static MovieRepository _instance = MovieRepository._internal();
  MovieApiProvide movieApiProvide;
  static MovieRepository get instance => _instance;
  factory MovieRepository() {
    return _instance;
  }

  MovieRepository._internal() {
    movieApiProvide = MovieApiProvide();
  }


  Future<List<Movie>> fetchMovie(int page) =>
      movieApiProvide.fetchMovie(page);

  Future<List<Subtitle>> fetchSubtitle(String movieId) =>
      movieApiProvide.fetchSubtitle(movieId);
}