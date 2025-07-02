import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

const packetCost = 500;
const packetSize = 5;
const packetCarouselSize = 8;

class CardCubit extends Cubit<CardState> {
  CardCubit({
    required this.appCubit,
    required this.userRepository,
  }) : super(
          const CardState(),
        ) {
    loadCards();
  }

  final AppCubit appCubit;
  final UserRepository userRepository;

  AppUser? get currentUser => appCubit.state.user;
  Set<CollectibleCard> get userCardsCollection =>
      currentUser?.cardCollection ?? <CollectibleCard>{};
  bool get userHasEnoughCoins =>
      currentUser?.wealth != null && currentUser!.wealth >= packetCost;

  Future<void> loadCards() async {
    emit(state.copyWith(
      userCards: userCardsCollection,
    ));
  }

  Future<void> cardRevealed(CollectibleCard card) async {}

  Future<void> openAPack(CardPack pack) async {
    if (currentUser != null) {
      final Set<CollectibleCard> newCollection = {};
      newCollection.addAll(userCardsCollection);
      newCollection.addAll(pack.cards);

      final newCardsInThePack = pack.cards
          .where((card) => !userCardsCollection.any((c) => c.id == card.id))
          .toList();

      final AppUser newUser = currentUser!.copyWith(
        cardCollection: newCollection,
        wealth: currentUser!.wealth - packetCost,
      );
      await appCubit.updateUser(newUser);
      emit(state.copyWith(
          newCardsInTheLastPack: newCardsInThePack, userCards: newCollection));
    }
  }
}
