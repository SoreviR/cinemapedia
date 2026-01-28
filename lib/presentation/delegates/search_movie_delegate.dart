import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  final List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies =
      StreamController<List<Movie>>.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  void clearStream() {
    debouncedMovies.close();
  }

  void _onQQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
    });
  }

  @override
  String get searchFieldLabel => 'Search movies';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
            onPressed: () => query = '',
            icon: const Icon(Icons.clear_outlined)),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStream();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('Build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQQueryChanged(query);
    return StreamBuilder(
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _MovieItem(
                  movie: movie,
                  onMovieSelected: (context, movie) {
                    clearStream();
                    close(context, movie);
                  });
              // _MovieItem(movie: movie);
            },
          );
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final texStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        FadeIn(child: child),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.70 - 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: texStyle.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    (movie.overview.isNotEmpty)
                        ? Text(
                            movie.overview,
                            style: texStyle.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          )
                        : const SizedBox(),
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_outlined,
                          color: Colors.yellow.shade800,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          HumanFormats.number(movie.voteAverage, 1),
                          style: texStyle.bodyMedium!
                              .copyWith(color: Colors.yellow.shade900),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
