import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies/movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesLoading()) {
    getMovies();
  }
  void getMovies() async {
    try {
      final response = await Dio().get(
          'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3');
      emit(MoviesLoaded(movies: response.data['results'], selectedMovies: []));
    } catch (e) {
      emit(MoviesFailed());
      print('Error fetching popular movies: $e');
    }
  }

  void toggleSelectedMovie(dynamic movie) {
    final currentState = state;
    if (currentState is MoviesLoaded) {
      List<dynamic> updatedSelectedMovies = List.from(currentState.selectedMovies);
      if (updatedSelectedMovies.contains(movie)) {
        updatedSelectedMovies.remove(movie);
      } else {
        updatedSelectedMovies.add(movie);
      }
      emit(currentState.copyWith(selectedMovies: updatedSelectedMovies));
    }
  }

   void moviesToCart() {
    final currentState = state;
    if (currentState is MoviesLoaded && currentState.selectedMovies.isNotEmpty) {
      emit(MoviesCart(cartOMovies: currentState.selectedMovies));
    }
  }

  void updateSelectedMovieTickets(dynamic movie, int tickets) {
    final currentState = state;
    if (currentState is MoviesLoaded) {
      final updatedSelectedMovies = currentState.selectedMovies.map((selectedMovie) {
        if (selectedMovie['title'] == movie['title']) {
          return {
            ...selectedMovie,
            'tickets': tickets,
          };
        }
        return selectedMovie;
      }).toList();
      emit(currentState.copyWith(selectedMovies: updatedSelectedMovies));
    }
  }

}
