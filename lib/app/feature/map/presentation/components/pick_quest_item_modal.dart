import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/domain/quest_static_marker.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_cubit.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/modal/base_modal.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/utils/haversine_distance.dart';

const userDistanceToPickItem = 20; // meters

bool userCanPickItem(
    AppState appState, MapState mapState, GeoPoint itemPosition) {
  // In dev mode, the user can always pick items
  if (appState.devMode) return true;
  // Check if the user is close enough to the item
  final lastRecordedPosition = mapState.lastRecordedUserPosition;
  if (lastRecordedPosition == null) return false;
  // Calculate the distance between the item position and the last recorded user position
  final distance = haversineDistance(
    itemPosition.latitude,
    itemPosition.longitude,
    lastRecordedPosition.latitude,
    lastRecordedPosition.longitude,
  );
  return distance <= userDistanceToPickItem;
}

BasicQuest getQuestRelatedToQuestItem(
    AppState appState, QuestStaticMarker selectedQuestItem) {
  final acceptedQuests = appState.allQuests.allAcceptedQuests
      .expand((questByNpc) => questByNpc.quests)
      .toList();
  return acceptedQuests.firstWhere(
    (quest) => quest.uuid == selectedQuestItem.relatedQuestId,
    orElse: () => throw Exception(
        'Quest not found for selected quest item: ${selectedQuestItem.relatedQuestId}'),
  );
}

void showPickQuestItemModal(
    BuildContext context, QuestStaticMarker selectedQuestItem) {
  final mapCubit = context.read<MapCubit>();
  final appCubit = context.read<AppCubit>();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>.value(value: appCubit),
        BlocProvider<MapCubit>.value(value: mapCubit),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              final userCanPickTheItem =
                  userCanPickItem(appState, state, selectedQuestItem.geoPoint);
              final quest =
                  getQuestRelatedToQuestItem(appState, selectedQuestItem);
              return BaseModal(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: AppColors.palette_tertiary,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.palette_primary,
                          width: 2,
                        )),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const H3('Raccogli Oggetto'),
                        const SizedBox(height: 20),
                        switch (quest.type) {
                          QuestType.nftTreasureHunt => const Text(
                              'Nft Treasure Hunt',
                            ),
                          QuestType.talkToNpc => const Text('Talk to NPC'),
                          _ => Container(),
                        },
                        const SizedBox(height: 20),
                        if (!userCanPickTheItem)
                          const Text(
                            'Avvicinati all\'oggetto per raccoglierlo.',
                            style: TextStyle(
                              color: AppColors.shade_red_100,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade600,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Annulla',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: userCanPickTheItem
                                      ? Colors.green
                                      : Colors.grey,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Raccogli',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
