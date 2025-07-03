import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/components/npc_location_detail.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            backgroundColor: AppColors.palette_secondary,
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
              mapIsLoading: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.palette_primary,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading map...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
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
            ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}
