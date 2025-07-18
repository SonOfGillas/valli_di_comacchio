import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';

enum PackOpeningStage {
  initial, // Unopened pack - showing bouncing animation
  openingCards, // Cards being pulled out
  completed, // All cards revealed
}

class CardState extends Equatable {
  const CardState({
    this.userCards = const {},
    this.newCardsInTheLastPack = const [],
    this.currentPack,
    this.packOpeningStage = PackOpeningStage.initial,
    this.remainingCards = const [],
    this.revealedCards = const [],
    this.currentRevealedCard,
    this.isRevealingCard = false,
    this.selectedCardForInspection,
  });

  final Set<CollectibleCard> userCards;
  final List<CollectibleCard> newCardsInTheLastPack;
  final CardPack? currentPack;
  final PackOpeningStage packOpeningStage;
  final List<CollectibleCard> remainingCards;
  final List<CollectibleCard> revealedCards;
  final CollectibleCard? currentRevealedCard;
  final bool isRevealingCard;
  final CollectibleCard? selectedCardForInspection;

  CardState copyWith({
    Set<CollectibleCard>? userCards,
    List<CollectibleCard>? newCardsInTheLastPack,
    CardPack? currentPack,
    PackOpeningStage? packOpeningStage,
    List<CollectibleCard>? remainingCards,
    List<CollectibleCard>? revealedCards,
    CollectibleCard? currentRevealedCard,
    bool? isRevealingCard,
    CollectibleCard? selectedCardForInspection,
  }) {
    return CardState(
      userCards: userCards ?? this.userCards,
      newCardsInTheLastPack:
          newCardsInTheLastPack ?? this.newCardsInTheLastPack,
      currentPack: currentPack ?? this.currentPack,
      packOpeningStage: packOpeningStage ?? this.packOpeningStage,
      remainingCards: remainingCards ?? this.remainingCards,
      revealedCards: revealedCards ?? this.revealedCards,
      currentRevealedCard: currentRevealedCard,
      isRevealingCard: isRevealingCard ?? this.isRevealingCard,
      selectedCardForInspection: selectedCardForInspection,
    );
  }

  @override
  List<Object?> get props => [
        userCards,
        newCardsInTheLastPack,
        currentPack,
        packOpeningStage,
        remainingCards,
        revealedCards,
        currentRevealedCard,
        isRevealingCard,
        selectedCardForInspection,
      ];
}
