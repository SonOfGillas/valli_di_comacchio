import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';

class CardState extends Equatable {
  const CardState(
      {this.userCards = const {}, this.newCardsInTheLastPack = const []});

  final Set<CollectibleCard> userCards;
  final List<CollectibleCard> newCardsInTheLastPack;

  CardState copyWith({
    Set<CollectibleCard>? userCards,
    List<CollectibleCard>? newCardsInTheLastPack,
  }) {
    return CardState(
      userCards: userCards ?? this.userCards,
      newCardsInTheLastPack:
          newCardsInTheLastPack ?? this.newCardsInTheLastPack,
    );
  }

  @override
  List<Object?> get props => [userCards, newCardsInTheLastPack];
}
