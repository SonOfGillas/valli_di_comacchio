import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/need_generation_functions.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/production_generation_functions.dart';

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
  * it represents the amount of resource that the npc needs
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
  * demandNormalized is a number between -1 and 1 that represents the demand of the resource 
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
