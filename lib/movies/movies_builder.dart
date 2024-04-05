import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies/movies_cubit.dart';
import 'package:movies/movies/movies_state.dart';

class MoviesBuilder extends StatefulWidget {
  const MoviesBuilder({super.key});

  @override
  State<MoviesBuilder> createState() => _MoviesBuilderState();
}

class _MoviesBuilderState extends State<MoviesBuilder> {
  List<String> selectedMovies = [];

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
            return Column(
              children: [
                Expanded(
                  child: _buildMoviesListView(state.movies),
                ),
                if (selectedMovies.isNotEmpty)
                  Expanded(
                    child: _buildSelectedMoviesListView(),
                  ),
              ],
            );
          }
          if (state is MoviesFailed) {
            return Center(
              child: Text('Failed to fetch movies'),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            selectedMovies.clear();
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }

  Widget _buildMoviesListView(List<dynamic> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          title: Text(movie['title']),
          subtitle: Text(movie['overview']),
          leading: Image.network(
            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
            width: 100,
            fit: BoxFit.cover,
          ),
          onTap: () {
            setState(() {
              selectedMovies.add(movie['title'] + ': ' + movie['overview']);
            });
          },
        );
      },
    );
  }

  Widget _buildSelectedMoviesListView() {
    return ListView.builder(
      itemCount: selectedMovies.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(selectedMovies[index]),
        );
      },
    );
  }
}
