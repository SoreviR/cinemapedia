import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  ShellRoute(
      builder: (context, state, child) => HomeScreen(
            childView: child,
          ),
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) {
              return const HomeView();
            }),
        GoRoute(
            path: '/favorites',
            builder: (context, state) {
              return const FavoritesView();
            }),
        GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id';

              return MovieScreen(
                movieId: movieId,
              );
            }),
      ])
]);



// RUTAS DE LA APLICACIÓN PADRE/HIJO
// final appRouter = GoRouter(initialLocation: '/', routes: [
//   GoRoute(
//       path: '/',
//       name: HomeScreen.name,
//       builder: (context, state) => const HomeScreen(
//             childView: HomeView(),
//           ),
//       routes: [
        // GoRoute(
        //     path: 'movie/:id',
        //     name: MovieScreen.name,
        //     builder: (context, state) {
        //       final movieId = state.pathParameters['id'] ?? 'no-id';

        //       return MovieScreen(
        //         movieId: movieId,
        //       );
//             }),
//       ]),
// ]);
