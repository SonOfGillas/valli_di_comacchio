import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';

class WalksAndPlacesCubit extends Cubit<WalksAndPlacesState> {
  WalksAndPlacesCubit({required this.appCubit}) : super(WalksAndPlacesState()) {
    loadWalksAndPlaces();
  }

  final AppCubit appCubit;

  void loadWalksAndPlaces() {
    emit(state.copyWith(
      filteredWalks: [], // Load actual walks data here
      filteredNpcs: appCubit.state.npcs,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
        filter: null, filteredWalks: [], filteredNpcs: appCubit.state.npcs));
  }

  void search(String query) {
    final filteredNpcs = appCubit.state.npcs
        .where((npc) =>
            npc.locationName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(filter: query, filteredNpcs: filteredNpcs));
  }
}
