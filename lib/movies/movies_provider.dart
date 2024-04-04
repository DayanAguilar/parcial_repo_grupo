


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies/movies_builder.dart';
import 'package:movies/movies/movies_cubit.dart';

class MoviesProvider extends StatelessWidget {
  const MoviesProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesCubit()..getMovies(),
      child: Scaffold(
        body: MoviesBuilder(),
      ),
    );
  }
}





