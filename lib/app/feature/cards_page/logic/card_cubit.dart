import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

const packetCost = 2500;
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

  // Initialize pack opening
  void startPackOpening(CardPack pack) {
    emit(state.copyWith(
      currentPack: pack,
      packOpeningStage: PackOpeningStage.initial,
      remainingCards: List.from(pack.cards),
      revealedCards: [],
      currentRevealedCard: null,
      isRevealingCard: false,
    ));
  }

  // Start revealing cards from the pack
  void startRevealingCards() {
    if (state.packOpeningStage != PackOpeningStage.initial) return;

    emit(state.copyWith(packOpeningStage: PackOpeningStage.openingCards));
    revealNextCard();
  }

  // Reveal the next card
  void revealNextCard() {
    if (state.packOpeningStage != PackOpeningStage.openingCards) return;
    if (state.isRevealingCard) return;
    if (state.remainingCards.isEmpty) return;

    // Pick a random card from the remaining cards
    final random = Random();
    final index = random.nextInt(state.remainingCards.length);
    final card = state.remainingCards[index];

    // Remove the card from remaining cards
    final updatedRemainingCards =
        List<CollectibleCard>.from(state.remainingCards);
    updatedRemainingCards.removeAt(index);

    emit(state.copyWith(
      isRevealingCard: true,
      currentRevealedCard: card,
      remainingCards: updatedRemainingCards,
    ));

    // Add the card to the user's collection
    cardRevealed(card);
  }

  // Complete the card reveal animation
  void completeCardReveal() {
    if (!state.isRevealingCard || state.currentRevealedCard == null) return;

    final updatedRevealedCards =
        List<CollectibleCard>.from(state.revealedCards);
    updatedRevealedCards.add(state.currentRevealedCard!);

    final isLastCard = state.remainingCards.isEmpty;

    emit(state.copyWith(
      revealedCards: updatedRevealedCards,
      currentRevealedCard: null,
      isRevealingCard: false,
      packOpeningStage: isLastCard
          ? PackOpeningStage.completed
          : PackOpeningStage.openingCards,
    ));
  }

  // Skip card reveal animation
  void skipCardRevealAnimation() {
    if (!state.isRevealingCard || state.currentRevealedCard == null) return;
    completeCardReveal();
  }

  // Inspect a card
  void inspectCard(CollectibleCard card) {
    emit(state.copyWith(selectedCardForInspection: card));
  }

  // Close card inspection
  void closeCardInspection() {
    emit(state.copyWith(selectedCardForInspection: null));
  }

  // Reset pack opening state
  void resetPackOpening() {
    emit(state.copyWith(
      currentPack: null,
      packOpeningStage: PackOpeningStage.initial,
      remainingCards: [],
      revealedCards: [],
      currentRevealedCard: null,
      isRevealingCard: false,
      selectedCardForInspection: null,
    ));
  }

  // Navigation methods
  void showPackCarousel() {
    emit(state.copyWith(currentView: CardPageView.packCarousel));
  }

  void showMainCollection() {
    emit(state.copyWith(
      currentView: CardPageView.collection,
      selectedPack: null,
    ));
  }

  void showPackOpening(CardPack pack) {
    emit(state.copyWith(
      currentView: CardPageView.packOpening,
      selectedPack: pack,
    ));
    startPackOpening(pack);
  }

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
