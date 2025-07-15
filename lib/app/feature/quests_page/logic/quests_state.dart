import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';

enum QuestPageMode { acceptedQuests, npcList, npcQuests }

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
  final int selectedTabIndex;

  const QuestsState({
    required this.mode,
    required this.allQuests,
    this.selectedNpc,
    this.status = QuestPageStatus.idle,
    this.error,
    this.selectedTabIndex = 0,
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
      selectedTabIndex: 0,
    );
  }

  QuestsState copyWith({
    QuestPageMode? mode,
    AllQuests? allQuests,
    required Npc? selectedNpc,
    QuestPageStatus? status,
    String? error,
    int? selectedTabIndex,
  }) {
    return QuestsState(
      mode: mode ?? this.mode,
      allQuests: allQuests ?? this.allQuests,
      selectedNpc: selectedNpc,
      status: status ?? this.status,
      error: error,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        allQuests,
        selectedNpc,
        status,
        error,
        selectedTabIndex,
      ];
}
