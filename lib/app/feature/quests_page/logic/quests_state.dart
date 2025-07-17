import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

enum QuestPageMode { acceptedQuests, npcList, npcQuests }

enum QuestPageStatus {
  idle,
  loading,
  error,
}

class QuestsState extends Equatable {
  final QuestPageMode mode;
  final Npc? selectedNpc;
  final QuestPageStatus status;
  final String? error;
  final int selectedTabIndex;
  final BasicQuest? completedQuest;
  final BasicQuest? updatedQuest;

  const QuestsState({
    required this.mode,
    this.selectedNpc,
    this.status = QuestPageStatus.idle,
    this.error,
    this.selectedTabIndex = 0,
    this.completedQuest,
    this.updatedQuest,
  });

  factory QuestsState.initial() {
    return QuestsState(
      mode: QuestPageMode.acceptedQuests,
      selectedNpc: null,
      status: QuestPageStatus.idle,
      error: null,
      selectedTabIndex: 0,
      completedQuest: null,
      updatedQuest: null,
    );
  }

  QuestsState copyWith({
    QuestPageMode? mode,
    required Npc? selectedNpc,
    QuestPageStatus? status,
    String? error,
    int? selectedTabIndex,
    BasicQuest? completedQuest,
    BasicQuest? updatedQuest,
  }) {
    return QuestsState(
      mode: mode ?? this.mode,
      selectedNpc: selectedNpc,
      status: status ?? this.status,
      error: error,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      completedQuest: completedQuest,
      updatedQuest: updatedQuest,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        selectedNpc,
        status,
        error,
        selectedTabIndex,
        completedQuest,
      ];
}
