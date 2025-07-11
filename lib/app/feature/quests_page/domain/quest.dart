import 'package:uuid/uuid.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

enum QuestType {
  // birdWatching, <- use AI to recognize birds and give hints and rewards
  quiz,
  nftTreasureHunt,
  nftTreasureHide,
  talkToNpc,
}

const uuidGenerator = Uuid();

class BasicQuest {
  final String uuid;
  final QuestType type;
  final Npc npc;
  final int coinReward;
  final bool accepted;
//  final List<TradeResourceInventory> resourceReward;

  BasicQuest({
    required this.type,
    required this.npc,
    this.coinReward = 0,
    this.accepted = false,
  }) : uuid = uuidGenerator.v1();

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type.toString(),
      'npc': npc.toJson(),
      'coinReward': coinReward,
      'accepted': accepted,
    };
  }

  factory BasicQuest.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String?;
    final type = QuestType.values.firstWhere(
      (e) => e.toString() == typeString,
      orElse: () => QuestType.quiz,
    );

    return BasicQuest(
      type: type,
      npc: Npc.fromJson(json['npc'] as Map<String, dynamic>),
      coinReward: json['coinReward'] as int? ?? 0,
      accepted: json['accepted'] as bool? ?? false,
    );
  }
}
