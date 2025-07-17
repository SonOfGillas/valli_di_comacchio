import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';

class QuestPageParameters {
  final Npc? selectedNpc;
  final BasicQuest? completedQuest;

  QuestPageParameters({this.selectedNpc, this.completedQuest});
}

class QuestsCubit extends Cubit<QuestsState> {
  QuestsCubit({
    required this.appCubit,
    required QuestPageParameters parameters,
  }) : super(QuestsState.initial()) {
    loadQuests(parameters);
  }

  final AppCubit appCubit;

  List<Npc> get npcs => appCubit.state.npcs;
  List<QuestsByNpc> get acceptedQuests =>
      appCubit.state.allQuests.allAcceptedQuests;
  List<BasicQuest> get npcQuests => (state.selectedNpc != null)
      ? appCubit.state.allQuests.getNpcQuests(state.selectedNpc!)
      : [];

  void loadQuests(QuestPageParameters parameters) {
    emit(state.copyWith(
        selectedNpc: parameters.selectedNpc,
        status: QuestPageStatus.loading,
        completedQuest: parameters.completedQuest));
    if (parameters.selectedNpc != null) {
      emit(state.copyWith(
          mode: QuestPageMode.npcQuests,
          selectedNpc: parameters.selectedNpc,
          completedQuest: state.completedQuest,
          selectedTabIndex: 1)); // Switch to NPC quests tab
      _loadNpcQuests(parameters.selectedNpc!);
    } else {
      _loadLocalSavedQuests();
    }
  }

  void _loadNpcQuests(Npc npc) async {
    await appCubit.getNpcQuests(npc);
    emit(state.copyWith(
        mode: QuestPageMode.npcQuests,
        selectedNpc: npc,
        completedQuest: state.completedQuest,
        status: QuestPageStatus.idle));
  }

  void _loadLocalSavedQuests() async {
    await appCubit.getLocalSavedQuests();
    emit(state.copyWith(
        selectedNpc: state.selectedNpc,
        completedQuest: state.completedQuest,
        status: QuestPageStatus.idle));
  }

  void acceptQuest(BasicQuest quest) async {
    if (state.selectedNpc == null) {
      emit(state.copyWith(
        selectedNpc: state.selectedNpc,
        status: QuestPageStatus.error,
        error: 'No NPC selected for quest acceptance.',
      ));
      return;
    }
    await appCubit.acceptQuest(state.selectedNpc!, quest);
    emit(state.copyWith(
        selectedNpc: state.selectedNpc, status: QuestPageStatus.idle));
  }

  void showNpcQuests(Npc npc) {
    emit(state.copyWith(
        selectedNpc: npc,
        status: QuestPageStatus.loading,
        mode: QuestPageMode.npcQuests));
    _loadNpcQuests(npc);
  }

  void goToNpcList() {
    emit(state.copyWith(
        selectedNpc: null,
        status: QuestPageStatus.idle,
        mode: QuestPageMode.npcList));
  }

  void changeTab(int tabIndex) {
    QuestPageMode newMode;
    if (tabIndex == 0) {
      newMode = QuestPageMode.acceptedQuests;
    } else {
      if (state.selectedNpc == null) {
        newMode = QuestPageMode.npcList;
      } else {
        newMode = QuestPageMode.npcQuests;
      }
    }
    emit(state.copyWith(
        selectedNpc: state.selectedNpc,
        mode: newMode,
        selectedTabIndex: tabIndex));
  }
}
