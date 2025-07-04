import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/get_walk_from_file.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required this.userRepository,
    required this.npcRepository,
  }) : super(
          const AppState(),
        );

  final UserRepository userRepository;
  final NpcRepository npcRepository;

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
    final walk = await getWalkFromGpxFile('assets/walks/walks_1.gpx');
    return [walk];
  }

  Future<void> loadSetUpData(AppUser? loggedUser) async {
    final npcs = await getNpcsData();
    final walks = await getWalksData();
    emit(state.copyWith(user: loggedUser, npcs: npcs, walks: walks));
  }
}
