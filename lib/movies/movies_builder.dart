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
                  child:
                      _buildMoviesListView(state.movies, state.selectedMovies),
                ),
                if (state.selectedMovies.isNotEmpty)
                  Expanded(
                    child: _buildSelectedMoviesListView(state.selectedMovies),
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
          setState(() {});
        },
        child: Icon(Icons.clear),
      ),
    );
  }

  ListTile _buildListTile(dynamic movie) {
    return ListTile(
        title: Text(movie['title']),
        subtitle: Text(movie['overview']),
        leading: Image.network(
          'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
          width: 100,
          fit: BoxFit.cover,
        ));
  }

  Widget _buildMoviesListView(
      List<dynamic> movies, List<dynamic> selectedMovies) {
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
              selectedMovies.add({
                'title': movie['title'],
                'overview': movie['overview'],
                'poster_path': movie['poster_path'],
              });
            });
          },
        );
      },
    );
  }

  Widget _buildSelectedMoviesListView(List<dynamic> selectedMovies) {
    return Column(
      children: [
        Container(
          child: const Text("Peliculas seleccionadas"),
          padding: EdgeInsets.all(16.0),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedMovies.length,
            itemBuilder: (context, index) {
              final selectedMovie = selectedMovies[index];
              return ListTile(
                title: Text(selectedMovie['title']),
                subtitle: Text(selectedMovie['overview']),
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w500${selectedMovie['poster_path']}',
                  width: 100,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
