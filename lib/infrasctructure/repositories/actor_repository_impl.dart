import 'package:cinemapedia/domain/datasources/actors_datasources.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDatasources dataSource;

  ActorRepositoryImpl(this.dataSource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) {
    return dataSource.getActorsByMovie(movieID);
  }
}
