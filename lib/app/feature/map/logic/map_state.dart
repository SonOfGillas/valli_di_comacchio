import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_page.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';

class MapState extends Equatable {
  const MapState({
    required this.mapController,
    this.walk,
    this.enableTracking = false,
    this.showNpc = true,
    this.showWalk = false,
  });

  final MapController mapController;
  final Walk? walk;
  final bool enableTracking;
  final bool showNpc;
  final bool showWalk;

  factory MapState.initial(MapParameters? parameters) {
    // nord-ovest corner 44.715405, 12.084026
    // sud-ovest corner 44.538891, 12.089158
    // nord-east corner 44.710786, 12.225312
    // sud-est corner 44.544011, 12.277653

    // Calculate center point from the 4 corners
    const double centerLat =
        (44.715405 + 44.538891 + 44.710786 + 44.544011) / 4;
    const double centerLng =
        (12.084026 + 12.089158 + 12.225312 + 12.277653) / 4;

    return MapState(
        walk: parameters?.walk,
        mapController: MapController(
          initPosition: GeoPoint(latitude: centerLat, longitude: centerLng),
          areaLimit: const BoundingBox(
            east: 12.277653, // easternmost longitude
            north: 44.715405, // northernmost latitude
            south: 44.538891, // southernmost latitude
            west: 12.084026, // westernmost longitude
          ),
        ));
  }

  @override
  List<Object?> get props =>
      [walk, mapController, showNpc, enableTracking, showWalk];

  MapState copyWith({
    MapController? mapController,
    Walk? walk,
    bool? enableTracking,
    bool? showNpc,
    bool? showWalk,
  }) {
    return MapState(
      walk: walk ?? this.walk,
      mapController: mapController ?? this.mapController,
      enableTracking: enableTracking ?? this.enableTracking,
      showNpc: showNpc ?? this.showNpc,
      showWalk: showWalk ?? this.showWalk,
    );
  }
}
