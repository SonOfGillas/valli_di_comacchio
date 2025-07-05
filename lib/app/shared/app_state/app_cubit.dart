import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/event.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/event_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/walk_repository.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required this.userRepository,
    required this.npcRepository,
    required this.walkRepository,
    required this.eventRepository,
  }) : super(
          const AppState(),
        );

  final UserRepository userRepository;
  final NpcRepository npcRepository;
  final WalkRepository walkRepository;
  final EventRepository eventRepository;

  Future<void> setCurrentUser({
    required AppUser user,
  }) async {
    emit(state.copyWith(user: user));
  }

  Future<void> logout() async {
    final logoutResult =
        await userRepository.logout(isGuest: state.user?.isGuest ?? true);
    logoutResult.fold(
      onSuccess: (_) {
        emit(const AppState(user: null));
      },
      onFailure: (error) {
        // TODO: Handle error if needed
      },
    );
  }

  Future<bool> updateUser(AppUser user) async {
    final result = await userRepository.updateUserData(user: user);
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
    final npcsResult = await npcRepository.getAllNpcs();
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
    final walksResult = await walkRepository.getAllWalks();
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
    final eventsResult = await eventRepository.getAllEvents();
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

  Future<void> loadSetUpData(AppUser? loggedUser) async {
    // Launch all async operations in parallel
    final results = await Future.wait([
      getNpcsData(),
      getWalksData(),
      getEventsData(),
    ]);

    // Extract results from the list
    final npcs = results[0] as List<Npc>;
    final walks = results[1] as List<Walk>;
    final events = results[2] as List<Event>;

    emit(state.copyWith(
        user: loggedUser, npcs: npcs, walks: walks, events: events));
  }
}
