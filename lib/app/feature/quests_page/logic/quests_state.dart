import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';

enum QuestPageMode {
  acceptedQuests,
  npcQuests,
}

enum QuestPageStatus {
  idle,
  loading,
  error,
}

class QuestsState extends Equatable {
  final QuestPageMode mode;
  final AllQuests allQuests;
  final Npc? selectedNpc;
  final QuestPageStatus status;
  final String? error;

  const QuestsState({
    required this.mode,
    required this.allQuests,
    this.selectedNpc,
    this.status = QuestPageStatus.idle,
    this.error,
  });

  List<BasicQuest> get acceptedQuests => allQuests.allAcceptedQuests;
  List<BasicQuest> get npcQuests =>
      (selectedNpc != null) ? allQuests.getNpcQuests(selectedNpc!) : [];

  factory QuestsState.initial() {
    return QuestsState(
      mode: QuestPageMode.acceptedQuests,
      allQuests: AllQuests(),
      selectedNpc: null,
      status: QuestPageStatus.idle,
      error: null,
    );
  }

  QuestsState copyWith({
    QuestPageMode? mode,
    AllQuests? allQuests,
    Npc? selectedNpc,
    QuestPageStatus? status,
    String? error,
  }) {
    return QuestsState(
      mode: mode ?? this.mode,
      allQuests: allQuests ?? this.allQuests,
      selectedNpc: selectedNpc ?? this.selectedNpc,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        allQuests,
        selectedNpc,
        status,
        error,
      ];
}
