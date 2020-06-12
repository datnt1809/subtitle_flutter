class SubtitleList {
  final List<Subtitle> subtitles;

  SubtitleList({this.subtitles,});

  factory SubtitleList.fromJson(List<dynamic> parsedJson) {
    List<Subtitle> subtitles = new List<Subtitle>();
    subtitles = parsedJson.map((i)=>Subtitle.fromJson(i)).toList();
    return new SubtitleList(subtitles: subtitles);
  }
}

class Subtitle {
  int id;
  String imdbCode;
  String language;
  String releaseName;
  String owner;
  String subsceneLink;
  String subsceneFile;
  int positive;
  Null numberSeason;
  Null numberEpisode;
  int languageId;

  Subtitle(
      {this.id,
        this.imdbCode,
        this.language,
        this.releaseName,
        this.owner,
        this.subsceneLink,
        this.subsceneFile,
        this.positive,
        this.numberSeason,
        this.numberEpisode,
        this.languageId});

  Subtitle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imdbCode = json['imdb_code'];
    language = json['language'];
    releaseName = json['release_name'];
    owner = json['owner'];
    subsceneLink = json['subscene_link'];
    subsceneFile = json['subscene_file'];
    positive = json['positive'];
    numberSeason = json['number_season'];
    numberEpisode = json['number_episode'];
    languageId = json['language_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imdb_code'] = this.imdbCode;
    data['language'] = this.language;
    data['release_name'] = this.releaseName;
    data['owner'] = this.owner;
    data['subscene_link'] = this.subsceneLink;
    data['subscene_file'] = this.subsceneFile;
    data['positive'] = this.positive;
    data['number_season'] = this.numberSeason;
    data['number_episode'] = this.numberEpisode;
    data['language_id'] = this.languageId;
    return data;
  }
}