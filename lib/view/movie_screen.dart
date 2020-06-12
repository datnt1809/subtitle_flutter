import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysubtitle/bloc/movie_fetch_bloc.dart';
import 'package:mysubtitle/data/movie_repository.dart';
import 'package:mysubtitle/view/movie_list.dart';

class MovieScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>
      MovieState();
}

class MovieState extends State<MovieScreen> {
  MovieRepository movieRepository = new MovieRepository();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Subtitles'),
          bottom: TabBar(tabs: [
            Tab(text: 'Movie'),
            Tab(
              icon: Icon(Icons.directions_bike),
            ),
            Tab(
              icon: Icon(Icons.directions_boat),
            ),
          ]),
        ),
        body: TabBarView(children: [
          BlocProvider(
            create: (context) => MovieBloc()..add(MovieFetchEvent(1)),
            child: MovieListPage(),
          ),
          dramaList(),
          Icon(Icons.directions_bike),
        ]),
      ),
    );
  }

  Widget dramaList() {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(
          msg: "This is Center Short Toast",
          toastLength: Toast.LENGTH_SHORT,
        );
      },
      child: Center(
        child: Text(
          'Coming soon',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
