import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/map/map_page.dart';
import 'package:valli_di_comacchio/app/feature/slash/slash_screen.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';

final GoRouter router = GoRouter(
  initialLocation: RoutesPaths.root,
  routes: <RouteBase>[
    GoRoute(
      path: RoutesPaths.root,
      builder: (BuildContext context, GoRouterState state) {
        return const SlashScreen();
      },
    ),
    GoRoute(
      path: RoutesPaths.map,
      builder: (BuildContext context, GoRouterState state) {
        return const MapPage();
      },
    ),
    GoRoute(
      path: RoutesPaths.trade,
      builder: (BuildContext context, GoRouterState state) {
        final param = state.extra as TradePageParameters;
        return TradePage(tradePageParameters: param);
      },
    ),
  ],
);
