import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_cubit.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/app_icon_button/app_icon_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_location_detail/npc_location_detail.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        return BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            return Scaffold(
                appBar: ValliAppBar(),
                backgroundColor: AppColors.palette_secondary,
                body: Stack(
                  children: [
                    OSMFlutter(
                      controller: state.mapController,
                      onMapIsReady: (p0) {
                        if (state.walk != null) {
                          context.read<MapCubit>().drawSelectedWalk();
                        }
                      },
                      mapIsLoading: Center(
                        child: Container(
                          color: AppColors.palette_secondary,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.palette_primary,
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              H3(
                                'Caricamento mappa . . .',
                              ),
                            ],
                          ),
                        ),
                      ),
                      osmOption: OSMOption(
                          userTrackingOption: UserTrackingOption(
                            enableTracking: state.enableTracking,
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
                            roadColor: Colors.blue,
                          ),
                          staticPoints: state.showNpc
                              ? appState.npcs
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
                                            latitude: npc.latitude,
                                            longitude: npc.longitude)
                                      ],
                                    ),
                                  )
                                  .toList()
                              : []),
                      onGeoPointClicked: (geoPoint) {
                        final npc = appState.npcs
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Column(
                        spacing: 8,
                        children: [
                          AppCircularIconButton(
                            onPressed: () {
                              context.read<MapCubit>().toggleShowTracking();
                            },
                            svgPath: AppIcons.gps,
                            selected: state.enableTracking,
                          ),
                          AppCircularIconButton(
                            onPressed: () {
                              context.read<MapCubit>().toggleShowNpc();
                            },
                            svgPath: AppIcons.npc,
                            selected: state.showNpc,
                          ),
                          if (state.walk != null)
                            AppCircularIconButton(
                              onPressed: () {
                                context.read<MapCubit>().toggleShowWalk();
                              },
                              svgPath: AppIcons.distance,
                              selected: state.showWalk,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: FooterNavBar());
          },
        );
      },
    );
  }
}
