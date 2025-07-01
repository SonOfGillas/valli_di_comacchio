import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class CardCubit extends Cubit<CardState> {
  CardCubit({
    required this.appStorage,
    required this.userRepository,
  }) : super(
          const CardState(),
        ) {
    loadUserCards();
  }

  final AppStorage appStorage;
  final UserRepository userRepository;

  Future<void> loadUserCards() async {
    final userCards =
        <CollectibleCard>[]; // await userRepository.getUserCards();
    emit(state.copyWith(userCards: userCards));
  }

  Future<void> addCardToCollection(CollectibleCard card) async {
    final cardAlreadyExists = state.userCards.any((c) => c.id == card.id);

    if (!cardAlreadyExists) {
      var newUserCards = [...state.userCards, card];
      emit(state.copyWith(
        userCards: newUserCards,
        lastPacketCards: [...state.lastPacketCards, card],
      ));
    }
  }

  Future<void> openAPack() async {
    emit(state.copyWith(lastPacketCards: []));
  }
}
