import 'dart:math';

import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';

const cardWeightCoeff = 100;
// for each card in appCardsCompleteList add add in weightedCardList 100/card.rarity instance of that card
final weightedCardList = appCardsCompleteList
    .expand(
        (card) => List.filled((cardWeightCoeff / card.rarity).round(), card))
    .toList();

CollectibleCard getRandomCard() {
  final random = Random();
  final index = random.nextInt(weightedCardList.length);
  return weightedCardList[index];
}

const packetSize = 5;

CardPack getRandomPacket() {
  final packet = <CollectibleCard>[];
  for (var i = 0; i < packetSize; i++) {
    packet.add(getRandomCard());
  }
  return CardPack(
    cards: packet,
  );
}
