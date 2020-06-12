import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysubtitle/data/movie_repository.dart';
import 'package:mysubtitle/simple_bloc_delegate.dart';
import 'package:mysubtitle/view/movie_screen.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: MovieScreen(),
      ),
      theme: ThemeData(
        fontFamily: "GoogleSans",
        primarySwatch: Colors.blue,
      ),
    );
  }
}


