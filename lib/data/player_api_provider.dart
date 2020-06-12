import 'dart:convert';

import 'package:mysubtitle/data/response/api_models.dart';
import 'package:http/http.dart' as http;
import 'package:mysubtitle/data/response/api_subtitle.dart';
class MovieApiProvide{

  String baseUrl = "https://subsapi.xyz/api/v2/";
  final successCode = 200;

  Future<List<Movie>> fetchMovie(int page) async {
    final response = await http.get(baseUrl + "movie?page=" + page.toString());

    return parseResponse(response);
  }

  Future<List<Subtitle>> fetchSubtitle(String movieId) async {
    final response = await http.get(baseUrl + "movie/" + movieId + "/subtitle");

    return parseSubtitleResponse(response);
  }


  List<Movie> parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);

    if (response.statusCode == successCode) {
      return ApiResult.fromJson(responseString).result;
    } else {
      throw Exception('failed to load players');
    }
  }

  List<Subtitle> parseSubtitleResponse(http.Response response) {
    final responseString = jsonDecode(response.body);
    if (response.statusCode == successCode) {
      return SubtitleList.fromJson(responseString).subtitles;
    } else {
      throw Exception('failed to load players');
    }
  }
}