class ApiResult {
  List<Movie> result;
  Paging paging;

  ApiResult({this.result, this.paging});

  ApiResult.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<Movie>();
      json['result'].forEach((v) {
        result.add(new Movie.fromJson(v));
      });
    }
    paging =
    json['paging'] != null ? new Paging.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    if (this.paging != null) {
      data['paging'] = this.paging.toJson();
    }
    return data;
  }
}

class Movie {
  String id;
  String title;
  String description;
  String genres;
  double imdbRating;
  String language;
  String runtime;
  String director;
  int year;
  String writer;
  String actors;
  String production;
  String ytTrailerCode;
  int isSerie;

  Movie(
      {this.id,
        this.title,
        this.description,
        this.genres,
        this.imdbRating,
        this.language,
        this.runtime,
        this.director,
        this.year,
        this.writer,
        this.actors,
        this.production,
        this.ytTrailerCode,
        this.isSerie});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    genres = json['genres'];
    imdbRating = json['imdb_rating'].toDouble();
    language = json['language'];
    runtime = json['runtime'];
    director = json['director'];
    year = json['year'];
    writer = json['writer'];
    actors = json['actors'];
    production = json['production'];
    ytTrailerCode = json['yt_trailer_code'];
    isSerie = json['is_serie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['genres'] = this.genres;
    data['imdb_rating'] = this.imdbRating;
    data['language'] = this.language;
    data['runtime'] = this.runtime;
    data['director'] = this.director;
    data['year'] = this.year;
    data['writer'] = this.writer;
    data['actors'] = this.actors;
    data['production'] = this.production;
    data['yt_trailer_code'] = this.ytTrailerCode;
    data['is_serie'] = this.isSerie;
    return data;
  }
}

class Paging {
  int count;
  int page;
  int limit;

  Paging({this.count, this.page, this.limit});

  Paging.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}