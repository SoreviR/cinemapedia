import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingmovies = ref.watch(nowPlayingMoviesProvider);

  if (nowPlayingmovies.isEmpty) return [];
  return nowPlayingmovies.sublist(0, 6);
});
