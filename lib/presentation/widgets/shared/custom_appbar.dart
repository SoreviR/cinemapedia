import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              Icons.movie_creation_outlined,
              color: theme.primary,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'CinemaFans',
              style: titleStyle,
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  final movieRepository = ref.read(movieRepositoryProvider);

                  showSearch(
                      context: context,
                      delegate: SearchMovieDelegate(
                          searchMovies: movieRepository.searchMovie));
                },
                icon: const Icon(Icons.search))
          ],
        ),
      ),
    ));
  }
}
