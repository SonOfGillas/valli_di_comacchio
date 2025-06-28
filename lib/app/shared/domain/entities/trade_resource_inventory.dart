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
    required this.storage,
    required this.needs,
    required this.lastReset,
  });

  factory TradeResourceInventory({
    required TradeResource tradeResource,
    required ProductionLevel defaultProductionLevel,
    required NeedLevel defaultNeedLevel,
    required DateTime lastReset,
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
      lastReset: lastReset,
    );
  }

  final TradeResource tradeResource;
  final ProductionLevel defaultProductionLevel;
  final NeedLevel defaultNeedLevel;
  final DateTime lastReset;

  /*
  * storage is a number between 0 and tradeResource.storageLimit
  * it represents the amount of resource that the npc has
  */
  final int storage;

  /*
  * needs is a number between 0 and tradeResource.storageLimit
  * it represents the amount of resource that the npc needs.
  * it is a fixed value, it change only after long periods of time
  * it must not be confused with the demand of the resource.
  */
  final int needs;

  int get demand {
    return (needs - storage);
  }

  /*
  * demandNormalized is a number that represents the demand of the resource as a percentage
  * this is compared to the overall need of that resource by the NPC.
  * for example: 
  * 1 means that the NPC miss the 100% of the resource he needs,
  * -1 means that the NPC has the double amount of resource he needs
  * this value can't never be more than 1 but it can be less than -1.
  * With the demandAfterTransactionNormalized it's use to calculate the acceptable price limits for the NPC.
  */
  double get demandNormalized {
    if (needs == 0) {
      // considered as if need is 1 to avoid division by zero
      return demand.toDouble();
    }
    return demand / needs;
  }

  /*
  * this method is used by the NPC to calculate the demand of the resource
  * after a buying transaction. the user is buying a resource from the npc
  */
  int demandAfterBuingTransaction(int transactionAmount) {
    if (transactionAmount < 0) {
      return demand;
    } else {
      return (needs - (storage - transactionAmount));
    }
  }

  /*
  * this method is used by the NPC to calculate the demand of the resource
  * after a selling transaction. the user is selling a resource to the npc
  */
  int demandAfterSellingTransaction(int transactionAmount) {
    if (transactionAmount < 0) {
      return demand;
    } else if (storage - transactionAmount < 0) {
      return 0;
    } else {
      return (needs - (storage + transactionAmount));
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
      lastReset: lastReset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tradeResourceID': tradeResource.id,
      'defaultProductionLevel': defaultProductionLevel.value,
      'defaultNeedLevel': defaultNeedLevel.value,
      'storage': storage,
      'needs': needs,
      'lastReset': lastReset.millisecondsSinceEpoch,
    };
  }

  factory TradeResourceInventory.fromJson(Map<String, dynamic> json) {
    final tradeResourceId = json['tradeResourceID'] as String;
    final tradeResource = tradeResourcesList.firstWhere(
      (element) => element.id == tradeResourceId,
      orElse: () => throw Exception('TradeResource not found'),
    );
    return TradeResourceInventory._(
      tradeResource: tradeResource,
      defaultProductionLevel:
          productionLevelFromValue(json['defaultProductionLevel'] as double),
      defaultNeedLevel: needLevelFromValue(json['defaultNeedLevel'] as double),
      storage: json['storage'] as int? ?? 0,
      needs: json['needs'] as int? ?? 0,
      lastReset: DateTime.fromMillisecondsSinceEpoch(
        json['lastReset'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
