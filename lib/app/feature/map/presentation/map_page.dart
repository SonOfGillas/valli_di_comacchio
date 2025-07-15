import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_cubit.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_screen.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class MapParameters {
  Walk? walk;
  GeoPoint? positionToShow;

  MapParameters({this.walk, this.positionToShow});
}

class MapPage extends StatelessWidget {
  const MapPage({super.key, required this.mapParameters});

  final MapParameters mapParameters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapCubit>(
      create: (context) => sl<MapCubit>(param1: mapParameters),
      child: MapScreen(),
    );
  }
}
