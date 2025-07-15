import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/home/logic/home_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.appCubit}) : super(HomeState()) {
    loadWalksAndPlaces();
  }

  final AppCubit appCubit;

  get unfilteredWalks => appCubit.state.walks;
  get unfilteredNpcs => appCubit.state.npcs;

  void loadWalksAndPlaces() async {
    emit(state.copyWith(
      filteredWalks: unfilteredWalks,
      filteredNpcs: unfilteredNpcs,
      filteredEvents: appCubit.state.events,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      filter: null,
      filteredWalks: unfilteredWalks,
      filteredNpcs: unfilteredNpcs,
      filteredEvents: appCubit.state.events,
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
    final filteredEvents = appCubit.state.events
        .where(
            (event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(
      filter: query,
      filteredNpcs: filteredNpcs,
      filteredWalks: filteredWalks,
      filteredEvents: filteredEvents,
    ));
  }
}
