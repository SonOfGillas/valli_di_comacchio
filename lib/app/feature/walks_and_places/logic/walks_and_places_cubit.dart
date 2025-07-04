import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';

class WalksAndPlacesCubit extends Cubit<WalksAndPlacesState> {
  WalksAndPlacesCubit({required this.appCubit}) : super(WalksAndPlacesState()) {
    loadWalksAndPlaces();
  }

  final AppCubit appCubit;

  get unfilteredWalks => appCubit.state.walks;
  get unfilteredNpcs => appCubit.state.npcs;

  void loadWalksAndPlaces() async {
    emit(state.copyWith(
      filteredWalks: unfilteredWalks,
      filteredNpcs: unfilteredNpcs,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      filter: null,
      filteredWalks: unfilteredWalks,
      filteredNpcs: unfilteredNpcs,
    ));
  }

  void search(String query) {
    final filteredWalks = unfilteredWalks
        .where((walk) => walk.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final filteredNpcs = unfilteredNpcs
        .where((npc) =>
            npc.locationName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(
        filter: query,
        filteredNpcs: filteredNpcs,
        filteredWalks: filteredWalks));
  }
}
