import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/domain/map_quest_items.dart';
import 'package:valli_di_comacchio/app/feature/map/domain/quest_static_marker.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_state.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_page.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.parameters, required this.appCubit})
      : super(MapState.initial(parameters));

  final AppCubit appCubit;
  final MapParameters parameters;

  List<Npc> get npcs => appCubit.state.npcs;
  List<QuestStaticMarker> get acceptedQuests =>
      getQuestStaticMarkers(appCubit.state.allQuests.allAcceptedQuests);

  static List<QuestStaticMarker> getQuestStaticMarkers(
      List<QuestsByNpc> questsByNpcList) {
    return questsByNpcList
        .expand((questByNpc) => questByNpc.quests)
        .map((quest) => MapQuestItems(quest: quest))
        .where((questItem) => questItem.geoPoints.isNotEmpty)
        .expand((questItem) =>
            questItem.geoPoints.map((geoPoint) => QuestStaticMarker(
                  icon: questItem.icon,
                  geoPoint: geoPoint,
                  relatedQuest: questItem.quest,
                )))
        .toList();
  }

  void drawPositionToShowMarker() async {
    if (state.positionToShow != null) {
      final geoPoint = state.positionToShow!;
      await state.mapController.addMarker(geoPoint);
      state.mapController.setMarkerIcon(
        geoPoint,
        MarkerIcon(
          iconWidget: Container(
            key: const ValueKey('positionToShowMarker'),
            child: const Icon(Icons.location_on, color: Colors.red, size: 80),
          ),
        ),
      );
      await state.mapController.moveTo(geoPoint);
      await state.mapController.setZoom(
        zoomLevel: 15,
      );
    }
  }

  void drawSelectedWalk() async {
    if (state.walk != null) {
      emit(state.copyWith(
          enableTracking: false, showNpc: false, showWalk: true));
      final firstGeoPoint = state.walk!.trackGeoPoints.first;
      final lastGeoPoint = state.walk!.trackGeoPoints.last;
      final geoPointBetweenFirstAndLast = state.walk!.trackGeoPoints
          .sublist(1, state.walk!.trackGeoPoints.length - 1);
      await state.mapController.drawRoad(
        firstGeoPoint,
        lastGeoPoint,
        roadType: RoadType.foot,
        intersectPoint: geoPointBetweenFirstAndLast,
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

  void toggleShowNpc() {
    emit(state.copyWith(showNpc: !state.showNpc));
    if (state.showNpc) {
      for (var npc in npcs) {
        final npcGeoPoint = GeoPoint(
          latitude: npc.latitude,
          longitude: npc.longitude,
        );
        state.mapController.addMarker(
          npcGeoPoint,
        );
        state.mapController.setMarkerIcon(
            npcGeoPoint,
            MarkerIcon(
              iconWidget: Container(
                key: ValueKey(npc.id),
                child: Image.asset(
                  npc.imageLocalPath,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ));
      }
    } else {
      final geoPoints = npcs
          .map(
            (npc) => GeoPoint(latitude: npc.latitude, longitude: npc.longitude),
          )
          .toList();
      state.mapController.removeMarkers(geoPoints);
    }
  }

  void toggleShowTracking() {
    if (state.enableTracking) {
      state.mapController.disabledTracking();
    } else {
      state.mapController.enableTracking();
    }
    emit(state.copyWith(enableTracking: !state.enableTracking));
  }

  void toggleShowWalk() {
    if (state.walk == null) return;
    if (state.showWalk) {
      state.mapController.removeLastRoad();
    } else {
      drawSelectedWalk();
    }
    emit(state.copyWith(showWalk: !state.showWalk));
  }

  BasicQuest? _checkTalkToNpcQuestCompletion(Npc selectedNpc) {
    final List<TalkToNpcQuest> acceptedTalkToNpcQuests = appCubit
        .state.allQuests
        .getQuestByType(QuestType.talkToNpc)
        .cast<TalkToNpcQuest>();
    final completedQuest = acceptedTalkToNpcQuests
        .where(
          (quest) =>
              quest.receiverNpc.id == selectedNpc.id && quest.allItemsFound,
        )
        .firstOrNull;
    return completedQuest;
  }

  void onGeoPointClicked(GeoPoint geoPoint) {
    final questMarker = acceptedQuests
        .where(
          (quest) => quest.geoPoint == geoPoint,
        )
        .firstOrNull;
    if (questMarker != null) {
      emit(state.copyWith(
        questItemSelected: questMarker,
      ));
      return;
    }
    final selectedNpc = npcs
        .where(
          (npc) =>
              npc.latitude == geoPoint.latitude &&
              npc.longitude == geoPoint.longitude,
        )
        .firstOrNull;
    if (selectedNpc != null) {
      final talkToNpcQuestCompleted =
          _checkTalkToNpcQuestCompletion(selectedNpc);
      if (talkToNpcQuestCompleted != null) {
        emit(state.copyWith(
          questCompleted: talkToNpcQuestCompleted,
        ));
      } else {
        emit(state.copyWith(
          npcLocationSelected: selectedNpc,
        ));
      }
    }
  }

  Future<void> recordUserPosition() async {
    try {
      final userPosition = await state.mapController.myLocation();
      emit(state.copyWith(lastRecordedUserPosition: userPosition));
    } catch (e) {
      print('Error getting user location: $e');
    }
  }
}
