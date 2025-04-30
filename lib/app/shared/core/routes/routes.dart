import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/home/home_page.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';

final GoRouter router = GoRouter(
  initialLocation: RoutesPaths.home,
  routes: <RouteBase>[
    GoRoute(
      path: RoutesPaths.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
  ],
);
