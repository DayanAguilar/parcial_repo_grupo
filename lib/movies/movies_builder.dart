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
        title: const Text('Peliculas'),
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MoviesLoaded) {
            return Column(
              children: [
                Expanded(
                  child: _buildMoviesListView(state.movies),
                ),
                if (state.selectedMovies.isNotEmpty)
                  Expanded(
                    child: _buildSelectedMoviesListView(state.selectedMovies),
                  ),
                ElevatedButton(
                    onPressed: () {
                      context.read<MoviesCubit>().moviesToCart();
                    },
                    child: const Text("Añadir al carrito"))
              ],
            );
          } else if (state is MoviesFailed) {
            return const Center(
              child: Text('Failed to fetch movies'),
            );
          } else if (state is MoviesCart) {
            return Column(
              children: [
                Expanded(
                  child: _buildListTicketConfirmation(
                      state.cartOMovies), //cambiar funcion
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<MoviesCubit>().purchaseConfirmation();
                    },
                    child: const Text("Comprar entradas"))
              ],
            );
          } else if (state is MoviesConfirmation) {
            return Center(
              child: Text(
                'Peliculas compradas correctamente por ${state.price} Bs.',
              ),
            );
          }

          return Container();
        },
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
            context.read<MoviesCubit>().toggleSelectedMovie(movie);
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      selectedMovies.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListTicketConfirmation(dynamic cartOMovies) {
    return ListView.builder(
      itemCount: cartOMovies.length,
      itemBuilder: (context, index) {
        final selectedMovie = cartOMovies[index];
        return ListTile(
          title: Text(selectedMovie['title']),
          subtitle: Text(selectedMovie['overview']),
          leading: Image.network(
            'https://image.tmdb.org/t/p/w500${selectedMovie['poster_path']}',
            width: 100,
            fit: BoxFit.cover,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 24.0),
                  child: Text("${(selectedMovie['price'] ?? 0)} Bs")),
              _buildTicketSelector(context, selectedMovie),
              // Your additional text
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketSelector(BuildContext context, dynamic selectedMovie) {
    return ElevatedButton(
      onPressed: () {
        _showTicketInputDialog(
            context, selectedMovie, context.read<MoviesCubit>());
      },
      child: Text('Cantidad de Tickets'),
    );
  }

  void _showTicketInputDialog(
      BuildContext context, dynamic selectedMovie, MoviesCubit cubit) {
    int selectedTickets = selectedMovie['tickets'] ?? 1; // Default value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cantidad de Tickets'),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Selecciona la cantidad de tickets para ${selectedMovie['title']}'),
                    const SizedBox(height: 10),
                    DropdownButton<int>(
                      value: selectedTickets,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedTickets = newValue;
                          });
                        }
                      },
                      items: List.generate(10, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    cubit.updateSelectedMovieTickets(
                        selectedMovie, selectedTickets);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Se actualizo la cantidad de tickets'),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
