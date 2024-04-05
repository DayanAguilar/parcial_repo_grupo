class MoviesState {
  MoviesState();
}

class MoviesLoading extends MoviesState {
  MoviesLoading();
}

class MoviesFailed extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<dynamic> movies;
  final List<dynamic> selectedMovies;
  MoviesLoaded({required this.movies, required this.selectedMovies});
  @override
  List<Object?> get props => [movies, selectedMovies];
}

class MoviesCart extends MoviesState {
  final List<dynamic> cartOMovies;
  MoviesCart({required this.cartOMovies});

  @override
  List<Object> get props => [cartOMovies];
}
