import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysubtitle/bloc/subtitle_fetch_bloc.dart';
import 'package:mysubtitle/data/movie_repository.dart';
import 'package:mysubtitle/data/response/api_models.dart';
import 'package:mysubtitle/view/movie_detail/subtitle_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  MovieRepository movieRepository = MovieRepository.instance;
  final Movie movie;
  MovieDetailScreen({this.movie});

  @override
  State<StatefulWidget> createState() => MovieDetailState();
}

class MovieDetailState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      margin: EdgeInsets.all(4.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black45,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            headerWidget(),
            detailWidget(),
            Container(
              margin: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child:
              BlocProvider(
                create: (context) => SubtitleBloc(movieRepository: widget.movieRepository)..add(SubtitleFetchEvent(movieId: widget.movie.id)),
                child: SubtitleListScreen(),
              ),

            )

          ],
        ),
      )
    )));
  }

  Widget headerWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://img.youtube.com/vi/' +
                  widget.movie.ytTrailerCode +
                  '/maxresdefault.jpg',
              height: 80.0,
              width: 120.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              margin: EdgeInsets.only(left: 8.0),
              child: Text(
                widget.movie.title,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              margin: EdgeInsets.only(left: 8.0),
              child: Text(
                widget.movie.director,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Text(
                widget.movie.production,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 15,
                          color: Colors.white,
                        ),
                        Text(
                          widget.movie.imdbRating.toString() + ' imdb',
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: <Widget>[
                        Icon(
                          Icons.av_timer,
                          size: 15,
                          color: Colors.white,
                        ),
                        Text(
                          widget.movie.runtime,
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        )
                      ],
                    ))
              ],
            )
          ],
        )
      ],
    );
  }

  Widget detailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'Genres',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Wrap(
            children: wrapWidget(widget.movie.genres),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'Actors',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Wrap(
            children: wrapWidget(widget.movie.actors),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'Trailer',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () => setState(() {
              _launchInBrowser();
            }),
            child: Stack(
              children: <Widget>[
                Image(
                  image: CachedNetworkImageProvider( 'https://img.youtube.com/vi/' +widget.movie.ytTrailerCode +'/maxresdefault.jpg'),width: 200,
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 65,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ))
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'About Movie',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Container(
              child: Text(widget.movie.description))
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'List subtitles for ' + widget.movie.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  List<Widget> wrapWidget(String data) {
    List<Widget> widgets = [];
    data.split(',').forEach((element) {
      Widget genre = new Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(right: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
            border: new Border.all(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Text(element, style: TextStyle(color: Colors.black45),),
      );
      widgets..add(genre);
    });
    return widgets;
  }



  Future<void> _launchInBrowser() async {
    String url = 'https://www.youtube.com/watch?v='+widget.movie.ytTrailerCode;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
