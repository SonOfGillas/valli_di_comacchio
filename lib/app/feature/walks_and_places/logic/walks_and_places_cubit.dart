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
      walks: [], // Load actual walks data here
      npcs: appCubit.state.npcs,
    ));
  }
}
