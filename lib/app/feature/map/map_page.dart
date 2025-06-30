import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/feature/map/components/npc_location_detail.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            body: OSMFlutter(
              controller: MapController(
                initPosition:
                    GeoPoint(latitude: 44.672905, longitude: 12.197045),
                areaLimit: const BoundingBox(
                  east: 12.197045,
                  north: 44.672905,
                  south: 44.672905,
                  west: 12.197045,
                ),
              ),
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: false, // TODO remove this when ready
                  unFollowUser: true,
                ),
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: const RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                staticPoints: state.npcs
                    .map(
                      (npc) => StaticPositionGeoPoint(
                        npc.id,
                        MarkerIcon(
                          iconWidget: Image.asset(
                            npc.imageLocalPath,
                            height: 300,
                          ),
                        ),
                        [
                          GeoPoint(
                              latitude: npc.latitude, longitude: npc.longitude)
                        ],
                      ),
                    )
                    .toList(),
              ),
              onGeoPointClicked: (geoPoint) {
                final npc = state.npcs
                    .where(
                      (n) =>
                          n.latitude == geoPoint.latitude &&
                          n.longitude == geoPoint.longitude,
                    )
                    .firstOrNull;
                if (npc != null) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.85),
                    builder: (context) => NpcLocationDetail(
                      npc: npc,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  );
                }
              },
            ));
      },
    );
  }
}
