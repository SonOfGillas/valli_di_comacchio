import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            backgroundColor: AppColors.palette_secondary,
            body: state.status == QuestPageStatus.loading
                ? const Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      LabelText(
                          'Stiamo generando delle nuove missioni per te!'),
                    ],
                  ))
                : SingleChildScrollView(
                    child: state.mode == QuestPageMode.acceptedQuests
                        ? const AcceptedQuestsWidget()
                        : const NpcQuestsWidget(),
                  ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}

class AcceptedQuestsWidget extends StatelessWidget {
  const AcceptedQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          // Implement the UI for accepted quests
          children: [
            Text('Accepted Quests'),
            ...state.acceptedQuests.map((quest) {
              return ListTile(
                title: Text(quest.uuid),
                subtitle: Text(quest.type.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    // Handle quest completion
                  },
                ),
              );
            })
          ],
        );
      },
    );
  }
}

class NpcQuestsWidget extends StatelessWidget {
  const NpcQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('NPC Quests ${state.selectedNpc?.name ?? 'Unknown'}'),
            ...state.npcQuests.map((quest) {
              return switch (quest.type) {
                QuestType.quiz => QuizQuestWidget(quest: quest as QuizQuest),
                QuestType.talkToNpc =>
                  TalkToNpcQuestWidget(quest: quest as TalkToNpcQuest),
                QuestType.nftTreasureHunt =>
                  NftTreasureQuestWidget(quest: quest as NftTreasureQuest),
                QuestType.nftTreasureHide =>
                  NftTreasureQuestWidget(quest: quest as NftTreasureQuest),
              };
            })
          ],
        );
      },
    );
  }
}

class QuizQuestWidget extends StatelessWidget {
  final QuizQuest quest;

  const QuizQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          H2("Quiz"),
          Text(quest.quiz.question),
          ...quest.quiz.answers.map((answer) => ListTile(
                title: Text(answer.answer),
                onTap: () {
                  // Handle option selection
                },
              )),
          H3("Coin Reward: ${quest.coinReward}"),
        ],
      ),
    );
  }
}

class TalkToNpcQuestWidget extends StatelessWidget {
  final TalkToNpcQuest quest;

  const TalkToNpcQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          H2("Talk to NPC"),
          LabelText(
              '${quest.npc.name} vole che parli con ${quest.receiverNpc.name}'),
          Text(quest.talkToNpcData.message),
          LabelText('oggetti da trovare:'),
          ...quest.questItems.map((item) => ListTile(
                title: Text(item.itemName),
                subtitle: Text(
                    'lat ${item.itemLocation.latitude}\nlon ${item.itemLocation.longitude}'),
                leading: Icon(Icons.token),
                onTap: () {
                  // Handle item selection
                },
              )),
          H3("Coin Reward: ${quest.coinReward}"),
        ],
      ),
    );
  }
}

class NftTreasureQuestWidget extends StatelessWidget {
  final NftTreasureQuest quest;

  const NftTreasureQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (quest.type == QuestType.nftTreasureHunt)
              ? H2("NFT Treasure Hunt Quest")
              : H2("NFT Treasure Hide Quest"),
          if (quest.type == QuestType.nftTreasureHunt)
            Text(
                'Raggiungi la posizione: ${quest.location?.latitude}, ${quest.location?.longitude} per trovare il tesoro NFT.'),
          if (quest.type == QuestType.nftTreasureHide)
            Text('Nascondi l\'NFT per completare la missione.'),
          // display the Nft image (it is a file)
          if (quest.type == QuestType.nftTreasureHide) Image.file(quest.nft),
        ],
      ),
    );
  }
}
