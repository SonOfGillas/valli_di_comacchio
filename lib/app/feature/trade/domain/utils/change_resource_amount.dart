import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/offer_type.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

/// NOTE this is the definition of OfferType
/// buy -> the user is buying the resource from the NPC
/// sell -> the user is selling the resource to the NPC

User applyOfferToUser({required TradeResourceOffer offer, required User user}) {
  final wealthVartiationFactorUser = offer.offerType == OfferType.buy ? -1 : 1;
  final resourceAmountVariationFactorUser =
      offer.offerType == OfferType.buy ? 1 : -1;

  final wealthVariation = wealthVartiationFactorUser * offer.totalCost;
  final resourceAmountVariation =
      resourceAmountVariationFactorUser * offer.offerQuantity;

  return user.copyWith(
    wealth: user.wealth + wealthVariation,
    inventory: _updateInventoryAmount(
      offer.tradeResourceInventory.tradeResource,
      user.inventory,
      resourceAmountVariation,
    ),
  );
}

Npc applyOfferToNpc({required TradeResourceOffer offer, required Npc npc}) {
  final wealthVartiationFactorNpc = offer.offerType == OfferType.buy ? 1 : -1;
  final resourceAmountVariationFactorNpc =
      offer.offerType == OfferType.buy ? -1 : 1;

  final wealthVariation = wealthVartiationFactorNpc * offer.totalCost;
  final resourceAmountVariation =
      resourceAmountVariationFactorNpc * offer.offerQuantity;

  return npc.copyWith(
    wealth: npc.wealth + wealthVariation,
    inventory: _updateInventoryAmount(
      offer.tradeResourceInventory.tradeResource,
      npc.inventory,
      resourceAmountVariation,
    ),
  );
}

List<TradeResourceInventory> _updateInventoryAmount(
    TradeResource selectedResource,
    List<TradeResourceInventory> inventory,
    int resourceAmountVariation) {
  final updatedInventory = inventory.map((inventoryItem) {
    if (inventoryItem.tradeResource.id == selectedResource.id) {
      return inventoryItem.copyWith(
          storage: inventoryItem.storage ?? 0 + resourceAmountVariation);
    }
    return inventoryItem;
  }).toList();

  return updatedInventory;
}
