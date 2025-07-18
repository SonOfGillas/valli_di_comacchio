import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_cubit.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_state.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/components/pick_quest_item_modal.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/components/treasure_hide_dialog.dart';
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
        return BlocConsumer<MapCubit, MapState>(
          listener: (context, state) {
            if (state.npcLocationSelected != null) {
              showDialog(
                context: context,
                barrierColor: Colors.black.withValues(alpha: 0.85),
                builder: (context) => NpcLocationDetail(
                  npc: state.npcLocationSelected!,
                  onBack: () => Navigator.of(context).pop(),
                ),
              );
            }
            if (state.questItemSelected != null) {
              context.read<MapCubit>().recordUserPosition();
              showPickQuestItemModal(
                context,
                appState,
                state,
                state.questItemSelected!,
              );
            }
            if (state.questCompleted != null) {
              onQuestCompleated(context, state.questCompleted!);
            }
          },
          builder: (context, state) {
            final npcStaticPoints = appState.npcs
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
                      GeoPoint(latitude: npc.latitude, longitude: npc.longitude)
                    ],
                  ),
                )
                .toList();
            final acceptedQuestsStaticPoints = context
                .read<MapCubit>()
                .acceptedQuests
                .map((quest) => StaticPositionGeoPoint(
                    quest.id,
                    MarkerIcon(
                      iconWidget: SvgPicture.asset(
                        quest.icon,
                        height: 100,
                        colorFilter: ColorFilter.mode(
                          AppColors.palette_primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    [quest.geoPoint]))
                .toList();
            final acceptedNftTreasureQuests =
                context.read<MapCubit>().acceptedNftTreasureQuests;
            return Scaffold(
                appBar: ValliAppBar(),
                backgroundColor: AppColors.palette_secondary,
                floatingActionButton: acceptedNftTreasureQuests.isEmpty
                    ? null
                    : FloatingActionButton(
                        backgroundColor: AppColors.palette_primary,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => TreasureHideDialog(
                              acceptedNftTreasureQuests:
                                  acceptedNftTreasureQuests,
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          AppIcons.treasure_hide,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                            AppColors.palette_tertiary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                body: Stack(
                  children: [
                    OSMFlutter(
                      controller: state.mapController,
                      onMapIsReady: (p0) {
                        if (state.walk != null) {
                          context.read<MapCubit>().drawSelectedWalk();
                        }
                        if (state.positionToShow != null) {
                          context.read<MapCubit>().drawPositionToShowMarker();
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
                          initZoom: 7,
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
                            roadColor: Colors.purple,
                            roadBorderColor: Colors.purple,
                            roadWidth: 2,
                            roadBorderWidth: 4),
                        staticPoints: [
                          ...npcStaticPoints,
                          ...acceptedQuestsStaticPoints
                        ],
                      ),
                      onGeoPointClicked: (geoPoint) {
                        context.read<MapCubit>().onGeoPointClicked(geoPoint);
                      },
                    ),
                    BlocBuilder<MapCubit, MapState>(
                      buildWhen: (state, previous) =>
                          state.enableTracking != previous.enableTracking ||
                          state.showNpc != previous.showNpc ||
                          state.showWalk != previous.showWalk,
                      builder: (context, state) {
                        return Padding(
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
                              // AppCircularIconButton(
                              //   onPressed: () {
                              //     context.read<MapCubit>().toggleShowNpc();
                              //   },
                              //   svgPath: AppIcons.npc,
                              //   selected: state.showNpc,
                              // ),
                              // if (state.walk != null)
                              //   AppCircularIconButton(
                              //     onPressed: () {
                              //       context.read<MapCubit>().toggleShowWalk();
                              //     },
                              //     svgPath: AppIcons.distance,
                              //     selected: state.showWalk,
                              //   ),
                            ],
                          ),
                        );
                      },
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
