import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';

class CardState extends Equatable {
  const CardState({this.userCards = const [], this.lastPacketCards = const []});

  final List<CollectibleCard> userCards;
  final List<CollectibleCard> lastPacketCards;

  CardState copyWith({
    List<CollectibleCard>? userCards,
    List<CollectibleCard>? lastPacketCards,
  }) {
    return CardState(
      userCards: userCards ?? this.userCards,
      lastPacketCards: lastPacketCards ?? this.lastPacketCards,
    );
  }

  @override
  List<Object?> get props => [userCards, lastPacketCards];
}
