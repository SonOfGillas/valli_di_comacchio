import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/event.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/walk.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/event_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/quest_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/walk_repository.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required UserRepository userRepository,
    required NpcRepository npcRepository,
    required WalkRepository walkRepository,
    required EventRepository eventRepository,
    required QuestRepository questRepository,
  })  : _userRepository = userRepository,
        _npcRepository = npcRepository,
        _walkRepository = walkRepository,
        _eventRepository = eventRepository,
        _questRepository = questRepository,
        super(
          AppState(),
        );

  final UserRepository _userRepository;
  final NpcRepository _npcRepository;
  final WalkRepository _walkRepository;
  final EventRepository _eventRepository;
  final QuestRepository _questRepository;

  Future<void> setCurrentUser({
    required AppUser user,
  }) async {
    emit(state.copyWith(user: user));
  }

  Future<void> logout() async {
    final logoutResult =
        await _userRepository.logout(isGuest: state.user?.isGuest ?? true);
    logoutResult.fold(
      onSuccess: (_) {
        emit(AppState(user: null));
      },
      onFailure: (error) {
        // TODO: Handle error if needed
      },
    );
  }

  Future<bool> updateUser(AppUser user) async {
    final result = await _userRepository.updateUserData(user: user);
    bool successFullUpdate = false;
    result.fold(
      onSuccess: (_) {
        emit(state.copyWith(user: user));
        successFullUpdate = true;
      },
      onFailure: (error) {
        // TODO: Handle error if needed
      },
    );
    return successFullUpdate;
  }

  Future<List<Npc>> getNpcsData() async {
    List<Npc> npcsList = [];
    final npcsResult = await _npcRepository.getAllNpcs();
    npcsResult.fold(
      onSuccess: (npcs) {
        npcsList = npcs;
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error fetching NPCs: $error');
      },
    );
    return npcsList;
  }

  Future<List<Walk>> getWalksData() async {
    List<Walk> walks = [];
    final walksResult = await _walkRepository.getAllWalks();
    walksResult.fold(
      onSuccess: (fetchedWalks) {
        walks = fetchedWalks;
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error fetching walks: $error');
      },
    );
    return walks;
  }

  Future<List<Event>> getEventsData() async {
    List<Event> events = [];
    final eventsResult = await _eventRepository.getAllEvents();
    eventsResult.fold(
      onSuccess: (fetchedEvents) {
        events = fetchedEvents;
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error fetching events: $error');
      },
    );
    return events;
  }

  Future<bool> getIsDevMode() async {
    final result = await _userRepository.isDevUser();
    bool isDev = false;
    result.fold(onSuccess: (devMode) {
      emit(state.copyWith(devMode: devMode));
      isDev = devMode;
    });
    return isDev;
  }

  Future<List<File>> getCollectedNFTs() async {
    List<File> nfts = [];
    final nftsResult = await _questRepository.collectedNfts();
    nftsResult.fold(
      onSuccess: (fetchedNfts) {
        nfts = fetchedNfts;
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error fetching collected NFTs: $error');
      },
    );
    return nfts;
  }

  Future<void> loadSetUpData(AppUser? loggedUser) async {
    // Launch all async operations in parallel
    final results = await Future.wait([
      getNpcsData(),
      getWalksData(),
      getEventsData(),
      getIsDevMode(),
      getCollectedNFTs()
    ]);

    // Extract results from the list
    final npcs = results[0] as List<Npc>;
    final walks = results[1] as List<Walk>;
    final events = results[2] as List<Event>;
    final isDevMode = results[3] as bool;
    final collectedNFTs = results[4] as List<File>;

    emit(state.copyWith(
      user: loggedUser,
      npcs: npcs,
      walks: walks,
      events: events,
      devMode: isDevMode,
      collectedNFTs: collectedNFTs,
    ));
  }

  Future<void> setDevMode(bool isDev) async {
    final result = await _userRepository.setDevMode(isDev);
    result.fold(
      onSuccess: (_) {
        emit(state.copyWith(devMode: isDev));
      },
      onFailure: (error) {
        // Handle error if needed
      },
    );
  }

  Future<void> getNpcQuests(Npc npc) async {
    final result = await _questRepository.getNpcQuest(npc, state.npcs);
    result.fold(
      onSuccess: (quests) {
        emit(state.copyWith(allQuests: quests));
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error fetching NPC quests: $error');
      },
    );
  }

  Future<void> getLocalSavedQuests() async {
    final result = await _questRepository.localSavedQuests();
    result.fold(
      onSuccess: (quests) {
        emit(state.copyWith(allQuests: quests));
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error fetching local saved quests: $error');
      },
    );
  }

  Future<void> acceptQuest(Npc npc, BasicQuest quest) async {
    final result = await _questRepository.acceptQuest(npc, quest);
    result.fold(
      onSuccess: (quests) {
        emit(state.copyWith(allQuests: quests));
      },
      onFailure: (error) {
        // Handle error if needed
        print('Error accepting quest: $error');
      },
    );
    final updateNftCollection = await getCollectedNFTs();
    emit(state.copyWith(collectedNFTs: updateNftCollection));
  }
}
