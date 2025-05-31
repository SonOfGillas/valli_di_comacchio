import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/utils/need_generation_functions.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/utils/production_generation_functions.dart';

/*
* this class represents the trade resource in the inventory of an NPC .
* it extends the information of the trade resource with the amount of resource that the npc has and needs.
* it also has a method to calculate the demand of the resource.
*/
class TradeResourceInventory extends Equatable {
  const TradeResourceInventory._({
    required this.tradeResource,
    required this.defaultProductionLevel,
    required this.defaultNeedLevel,
    this.storage,
    this.needs,
  });

  factory TradeResourceInventory({
    required TradeResource tradeResource,
    required ProductionLevel defaultProductionLevel,
    required NeedLevel defaultNeedLevel,
    int? storage,
    int? needs,
  }) {
    return TradeResourceInventory._(
      tradeResource: tradeResource,
      defaultProductionLevel: defaultProductionLevel,
      defaultNeedLevel: defaultNeedLevel,
      storage: storage ??
          generateRandomStorageAmount(tradeResource, defaultProductionLevel),
      needs:
          needs ?? generateRandomNeedsAmount(tradeResource, defaultNeedLevel),
    );
  }

  final TradeResource tradeResource;
  final ProductionLevel defaultProductionLevel;
  final NeedLevel defaultNeedLevel;

  /*
  * storage is a number between 0 and tradeResource.storageLimit
  * it represents the amount of resource that the npc has
  */
  final int? storage;

  /*
  * needs is a number between 0 and tradeResource.storageLimit
  * it represents the amount of resource that the npc needs.
  * it is a fixed value, it change only after long periods of time
  * it must not be confused with the demand of the resource.
  */
  final int? needs;

  int get demand {
    if (needs == null || storage == null) {
      return 0;
    } else {
      return (needs! - storage!);
    }
  }

  /*
  * demandNormalized is a number between -1 and 1 that represents the demand of the resource,
  * With the demandAfterTransactionNormalized it's use to calculate the acceptable price limits for the NPC.
  * 1 means that the resource is needed in a large amount
  * -1 means that the npc wants to get rid of the resource
  */
  double get demandNormalized {
    final double min = -tradeResource.maxProduction;
    final double max = tradeResource.maxNeed;
    final double value = demand.toDouble();

    // Normalize demand between -1 and 1
    return (value - min) / (max - min) * 2 - 1;
  }

  /*
  * this method is used by the NPC to calculate the demand of the resource
  * after a buying transaction. the user is buying a resource from the npc
  */
  int demandAfterBuingTransaction(int transactionAmount) {
    if (needs == null || storage == null || transactionAmount < 0) {
      return demand;
    } else {
      return (needs! - (storage! - transactionAmount));
    }
  }

  /*
  * this method is used by the NPC to calculate the demand of the resource
  * after a selling transaction. the user is selling a resource to the npc
  */
  int demandAfterSellingTransaction(int transactionAmount) {
    if (needs == null || storage == null || transactionAmount < 0) {
      return demand;
    } else if (storage! - transactionAmount < 0) {
      return 0;
    } else {
      return (needs! - (storage! + transactionAmount));
    }
  }

  @override
  List<Object?> get props => [tradeResource, storage, needs];

  TradeResourceInventory copyWith({
    int? storage,
  }) {
    return TradeResourceInventory(
      tradeResource: tradeResource,
      storage: storage ?? this.storage,
      needs: needs,
      defaultProductionLevel: defaultProductionLevel,
      defaultNeedLevel: defaultNeedLevel,
    );
  }
}
