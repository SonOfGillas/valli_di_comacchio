import 'dart:io';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

enum QuestType {
  // birdWatching,
  quiz,
  nftTreasureHunt,
  talkToNpc,
}

abstract class Quest {
  final QuestType type;
  final Npc npc;

  Quest({required this.type, required this.npc});
}

class QuizQuest extends Quest {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  QuizQuest({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    required super.npc,
  }) : super(type: QuestType.quiz);
}

class NftTreasureHuntQuest extends Quest {
  final File nft;
  final GeoPoint location;

  NftTreasureHuntQuest({
    required this.nft,
    required this.location,
    required super.npc,
  }) : super(type: QuestType.nftTreasureHunt);
}

class TalkToNpcQuest extends Quest {
  final String senderNpcMessage;
  final Npc receiverNpc;

  TalkToNpcQuest({
    required this.senderNpcMessage,
    required this.receiverNpc,
    required super.npc,
  }) : super(type: QuestType.talkToNpc);
}
