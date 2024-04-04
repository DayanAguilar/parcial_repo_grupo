class MoviesState{
  MoviesState();
}
class MoviesLoading extends MoviesState{
  MoviesLoading();
}
class MoviesFailed extends MoviesState{
  
}
class MoviesLoaded extends MoviesState{
  final List<dynamic> movies;
  MoviesLoaded({required this.movies});
  @override
  List<Object?> get props => [movies];
}