import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies/movies_cubit.dart';
import 'package:movies/movies/movies_state.dart';

class MoviesBuilder extends StatelessWidget {
  const MoviesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Popular Movies'),
        ),
        body: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is MoviesLoaded) {
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return ListTile(
                    title: Text(movie['title']),
                    subtitle: Text(movie['overview']),
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }
            if (state is MoviesFailed) {
              return Center(
                child: Text('Failed to fetch movies'),
              );
            }
            return Container();
          },
        ));
  }
}
