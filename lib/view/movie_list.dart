import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysubtitle/bloc/movie_fetch_bloc.dart';
import 'package:mysubtitle/data/response/api_models.dart';
import 'package:mysubtitle/view/movie_detail/movie_detail_screen.dart';

import 'message.dart';

class MovieListPage extends StatefulWidget {
  @override
  MovieListState createState() => new MovieListState();
}

class MovieListState extends State<MovieListPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  MovieBloc _postBloc;
  MovieFetchedState movieFetchedState;

  @override
  // ignore: must_call_super
  void initState() {
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<MovieBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieFetchState>(builder: (context, state) {
      if (state is MovieUninitializedState) {
        return Message(message: "Unintialised State");
      } else if (state is MovieEmptyState) {
        return Container(
          alignment: Alignment.center,
          child: Center(
            child: SizedBox(
              width: 33,
              height: 33,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
          ),
        );
      } else if (state is MovieErrorState) {
        return Message(message: "Something went wrong");
      } else {
        movieFetchedState = state as MovieFetchedState;
        return buildPlayersList(movieFetchedState);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.add(MovieFetchEvent(movieFetchedState.page));
    }
  }

  Widget buildPlayersList(MovieFetchedState state) {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        return  index >= state.movies.length
            ? BottomLoader()
            : MovieWidget(movie: state.movies[index]);
      },
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          height: 8.0,
          color: Colors.transparent,
        );
      },
      itemCount: state.hasReachedMax ? state.movies.length : state.movies.length + 1,
      controller: _scrollController,
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class MovieWidget extends StatelessWidget{
  final Movie movie;
  const MovieWidget({Key key, @required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: Container(
            height: 100,
            child: ListTile(
              leading: Container(
                width: 80,
                child: Image(
                  image: CachedNetworkImageProvider( 'https://img.youtube.com/vi/' +movie.ytTrailerCode +'/maxresdefault.jpg'),
                )

              ),
              title: Text(
                movie.title + " (" + movie.year.toString() + ")",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                movie.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.0, color: Colors.black45),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
