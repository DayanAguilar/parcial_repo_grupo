class MoviesState {
  MoviesState();

  MoviesState copyWith({
    List<dynamic>? movies,
    List<dynamic>? selectedMovies,
    List<dynamic>? cartOMovies,
  }) {
    return MoviesState();
  }
}

class MoviesLoading extends MoviesState {}

class MoviesFailed extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<dynamic> movies;
  final List<dynamic> selectedMovies;
  MoviesLoaded({required this.movies, required this.selectedMovies});

  @override
  MoviesState copyWith({
    List<dynamic>? movies,
    List<dynamic>? selectedMovies,
    List<dynamic>? cartOMovies,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      selectedMovies: selectedMovies ?? this.selectedMovies,
    );
  }
}

class MoviesCart extends MoviesState {
  final List<dynamic> cartOMovies;
  MoviesCart({required this.cartOMovies});

  @override
  MoviesState copyWith({
    List<dynamic>? movies,
    List<dynamic>? selectedMovies,
    List<dynamic>? cartOMovies,
  }) {
    return MoviesCart(
      cartOMovies: cartOMovies ?? this.cartOMovies,
    );
  }
}

class MoviesConfirmation extends MoviesState {
  final String price;
  MoviesConfirmation({required this.price});

  @override
  List<Object> get props => [price];
}
