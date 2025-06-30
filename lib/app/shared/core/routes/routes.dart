import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/auth/presentation/auth_page.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/cards_page.dart';
import 'package:valli_di_comacchio/app/feature/map/map_page.dart';
import 'package:valli_di_comacchio/app/feature/profile/profile_page.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/quests_page.dart';
import 'package:valli_di_comacchio/app/feature/slash/slash_screen.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/walks_and_places.dart';
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
      path: RoutesPaths.auth,
      builder: (BuildContext context, GoRouterState state) {
        return const AuthPage();
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
    GoRoute(
        path: RoutesPaths.profile,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        }),
    GoRoute(
        path: RoutesPaths.cards,
        builder: (BuildContext context, GoRouterState state) {
          return const CardsPage();
        }),
    GoRoute(
      path: RoutesPaths.walksAndPlaces,
      builder: (BuildContext context, GoRouterState state) {
        return const WalksAndPlacesPage();
      },
    ),
    GoRoute(
      path: RoutesPaths.quest,
      builder: (BuildContext context, GoRouterState state) {
        return const QuestsPage();
      },
    )
  ],
);
