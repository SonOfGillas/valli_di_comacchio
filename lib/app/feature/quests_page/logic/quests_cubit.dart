import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/quest_repository.dart';

class QuestPageParameters {
  final Npc? selectedNpc;

  QuestPageParameters({this.selectedNpc});
}

class QuestsCubit extends Cubit<QuestsState> {
  QuestsCubit({
    required this.appCubit,
    required this.questRepository,
    required QuestPageParameters parameters,
  }) : super(QuestsState.initial()) {
    loadQuests(parameters);
  }

  final AppCubit appCubit;
  final QuestRepository questRepository;

  List<Npc> get npcs => appCubit.state.npcs;

  void loadQuests(QuestPageParameters parameters) {
    emit(state.copyWith(status: QuestPageStatus.loading));
    if (parameters.selectedNpc != null) {
      emit(state.copyWith(
          mode: QuestPageMode.npcQuests,
          selectedNpc: parameters.selectedNpc,
          status: QuestPageStatus.loading,
          selectedTabIndex: 1)); // Switch to NPC quests tab
      _loadNpcQuests(parameters.selectedNpc!);
    } else {
      _loadLocalSavedQuests();
    }
  }

  void _loadNpcQuests(Npc npc) {
    questRepository.getNpcQuest(npc, appCubit.state.npcs).then((result) {
      result.fold(
        onSuccess: (quests) {
          emit(state.copyWith(
              mode: QuestPageMode.npcQuests,
              selectedNpc: npc,
              allQuests: quests,
              status: QuestPageStatus.idle));
        },
        onFailure: (failure) {
          emit(state.copyWith(
            status: QuestPageStatus.error,
            error: failure.message(),
          ));
        },
      );
    });
  }

  void _loadLocalSavedQuests() {
    questRepository.localSavedQuests().then((result) {
      result.fold(
        onSuccess: (quests) {
          emit(state.copyWith(allQuests: quests, status: QuestPageStatus.idle));
        },
        onFailure: (failure) {
          emit(state.copyWith(
            mode: QuestPageMode.acceptedQuests,
            status: QuestPageStatus.error,
            error: failure.message(),
          ));
        },
      );
    });
  }

  void acceptQuest(BasicQuest quest) {
    if (state.selectedNpc == null) {
      emit(state.copyWith(
        status: QuestPageStatus.error,
        error: 'No NPC selected for quest acceptance.',
      ));
      return;
    }
    questRepository.acceptQuest(state.selectedNpc!, quest).then((result) {
      result.fold(
        onSuccess: (quests) {
          emit(state.copyWith(allQuests: quests, status: QuestPageStatus.idle));
        },
        onFailure: (failure) {
          emit(state.copyWith(
            status: QuestPageStatus.error,
            error: failure.message(),
          ));
        },
      );
    });
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
        status: QuestPageStatus.idle, mode: QuestPageMode.npcList));
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
    emit(state.copyWith(mode: newMode, selectedTabIndex: tabIndex));
  }
}
