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
    return MapState(
        walk: parameters?.walk,
        mapController: MapController(
          initPosition: GeoPoint(latitude: 44.672905, longitude: 12.197045),
          areaLimit: const BoundingBox(
            east: 12.197045,
            north: 44.672905,
            south: 44.672905,
            west: 12.197045,
          ),
        ));
  }

  @override
  List<Object?> get props => [walk, mapController, showNpc, enableTracking];

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
