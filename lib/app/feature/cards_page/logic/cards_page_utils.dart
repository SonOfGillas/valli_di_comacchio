import 'dart:math';

import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';

// get a random card from the list of collectible cards appCardsCompleteList
// the randomicity is influcenced by the rarity of the card
// rarity 1 cards are more likely to be selected than rarity 2 cards
// max rarity is rarity 5
CollectibleCard getRandomCard() {
  final random = Random();
  final rarityDouble = generateGaussianRandomNumberInRange(1, 1.2, 1, 5.2);
  final rarity = rarityDouble.round();

  // Filter cards by the selected rarity
  final filteredCards =
      appCardsCompleteList.where((card) => card.rarity == rarity).toList();

  // Return a random card from the filtered list
  if (filteredCards.isNotEmpty) {
    return filteredCards[random.nextInt(filteredCards.length)];
  }

  // If no cards found, return a default card (optional)
  final commonCards = appCardsCompleteList
      .where((card) => card.rarity == 1 || card.rarity == 2)
      .toList();
  return commonCards[random.nextInt(commonCards.length)];
}

const packetSize = 5;

List<CollectibleCard> getRandomPacket() {
  final packet = <CollectibleCard>[];
  for (var i = 0; i < packetSize; i++) {
    packet.add(getRandomCard());
  }
  return packet;
}
