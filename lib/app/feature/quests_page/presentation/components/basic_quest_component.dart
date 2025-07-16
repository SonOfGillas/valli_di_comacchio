import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/nft_tresure_hunt_widget.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/quiz_quest_widget.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/talk_to_npc_widget.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class BasicQuestComponent extends StatelessWidget {
  final BasicQuest quest;

  const BasicQuestComponent({super.key, required this.quest});

  String get questIcon {
    return switch (quest.type) {
      QuestType.nftTreasureHunt => AppIcons.treasure_hunt,
      QuestType.nftTreasureHide => AppIcons.treasure_hide,
      QuestType.talkToNpc => AppIcons.chat,
      QuestType.quiz => AppIcons.quiz,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.palette_primary,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset(
                      questIcon,
                      height: 40,
                      colorFilter: ColorFilter.mode(
                        AppColors.palette_tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Expanded(
                    child: H2(switch (quest.type) {
                      QuestType.nftTreasureHunt => "Caccia al Tesoro",
                      QuestType.nftTreasureHide => "Nascondi il Tesoro",
                      QuestType.talkToNpc => "Parla con col personaggio",
                      QuestType.quiz => "Quiz",
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LabelText("Ricompensa: ${quest.coinReward}"),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppIcons.money,
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      AppColors.background_white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary_light,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    switch (quest.type) {
                      QuestType.quiz =>
                        QuizQuestWidget(quest: quest as QuizQuest),
                      QuestType.talkToNpc =>
                        TalkToNpcQuestWidget(quest: quest as TalkToNpcQuest),
                      QuestType.nftTreasureHunt => NftTreasureQuestWidget(
                          quest: quest as NftTreasureQuest),
                      QuestType.nftTreasureHide => NftTreasureQuestWidget(
                          quest: quest as NftTreasureQuest),
                    },
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: quest.accepted
                            ? DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.shade_green_100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 16.0),
                                  child: LabelText(
                                    'Accettata',
                                    withBoarder: true,
                                  ),
                                ))
                            : GlowingButton(
                                text: 'Accetta',
                                onPressed: () {
                                  context
                                      .read<QuestsCubit>()
                                      .acceptQuest(quest);
                                }),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
