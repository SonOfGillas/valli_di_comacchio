import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_location_detail/npc_location_detail.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:xml/xml.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapController;
  bool isWalkVisible = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initPosition: GeoPoint(latitude: 44.672905, longitude: 12.197045),
      areaLimit: const BoundingBox(
        east: 12.197045,
        north: 44.672905,
        south: 44.672905,
        west: 12.197045,
      ),
    );
  }

  Future<void> _toggleWalkRoute() async {
    try {
      if (isWalkVisible) {
        // Remove the walk route
        await mapController.removeLastRoad();
        setState(() {
          isWalkVisible = false;
        });
      } else {
        // For now, draw a sample route (replace with actual GPX coordinates)
        await mapController.drawRoad(
          GeoPoint(latitude: 44.672905, longitude: 12.197045),
          GeoPoint(latitude: 44.675000, longitude: 12.200000),
          roadType: RoadType.foot,
          roadOption: const RoadOption(
            roadColor: Colors.blue,
            roadWidth: 100.0,
            isDotted: true,
          ),
        );

        setState(() {
          isWalkVisible = true;
        });
      }
    } catch (e) {
      // Handle error loading walk route
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading walk route: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            backgroundColor: AppColors.palette_secondary,
            body: OSMFlutter(
              controller: mapController,
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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _toggleWalkRoute,
              backgroundColor:
                  isWalkVisible ? Colors.red : AppColors.palette_primary,
              icon: Icon(
                isWalkVisible ? Icons.visibility_off : Icons.route,
                color: Colors.white,
              ),
              label: Text(
                isWalkVisible ? 'Hide Walk' : 'Show Walk',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}
