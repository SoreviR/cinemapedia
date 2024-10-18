import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasources {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
