import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_state.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_page.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(MapParameters parameters) : super(MapState.initial(parameters));

  void drawSelectedWalk() async {
    if (state.walk != null) {
      emit(state.copyWith(enableTracking: false, showNpc: false));
      final firstGeoPoint = state.walk!.trackGeoPoints.first;
      final lastGeoPoint = state.walk!.trackGeoPoints.last;
      final geoPointBetweenFirstAndLast = state.walk!.trackGeoPoints
          .sublist(1, state.walk!.trackGeoPoints.length - 1);
      await state.mapController.drawRoad(
        firstGeoPoint,
        lastGeoPoint,
        roadType: RoadType.foot,
        intersectPoint: geoPointBetweenFirstAndLast,
        roadOption: const RoadOption(
            roadColor: Colors.purple,
            roadBorderColor: Colors.purple,
            roadWidth: 2,
            roadBorderWidth: 4),
      );
      // move the camera at the center of the walk
      final latMean = state.walk!.trackGeoPoints.fold(
            0.0,
            (sum, geoPoint) => sum + geoPoint.latitude,
          ) /
          state.walk!.trackGeoPoints.length;
      final lonMean = state.walk!.trackGeoPoints.fold(
            0.0,
            (sum, geoPoint) => sum + geoPoint.longitude,
          ) /
          state.walk!.trackGeoPoints.length;
      await state.mapController.moveTo(
        GeoPoint(latitude: latMean, longitude: lonMean),
      );
    }
  }

  void closeTracking() {
    emit(state.copyWith(walk: null));
  }
}
