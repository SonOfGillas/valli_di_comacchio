import 'package:equatable/equatable.dart';
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

class BasicQuest extends Equatable {
  final String uuid;
  final QuestType type;
  final Npc npc;
  final int coinReward;
  final bool accepted;
//  final List<TradeResourceInventory> resourceReward;

  const BasicQuest({
    required this.uuid,
    required this.type,
    required this.npc,
    this.coinReward = 0,
    this.accepted = false,
  });

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
      uuid: json['uuid'] as String,
      type: type,
      npc: Npc.fromJson(json['npc'] as Map<String, dynamic>),
      coinReward: json['coinReward'] as int? ?? 0,
      accepted: json['accepted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [uuid, type, npc, coinReward, accepted];

  BasicQuest copyWith({
    bool? accepted,
  }) {
    return BasicQuest(
      uuid: uuid,
      type: type,
      npc: npc,
      coinReward: coinReward,
      accepted: accepted ?? this.accepted,
    );
  }
}
