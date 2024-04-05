import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies/movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesLoading());
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

  void selectMovies() {}
}
