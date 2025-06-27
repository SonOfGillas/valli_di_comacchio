import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';

class ResourcesInventoryDataSourceMock implements ResourcesInventoryDataSource {
  var mockUserInventory = <TradeResourceInventory>[];
  var mockNpcInventory = <TradeResourceInventory>[];

  @override
  Future<List<TradeResourceInventory>> getNpcInventory(Npc npc) async {
    if (mockNpcInventory.isEmpty) {
      mockNpcInventory = _generateMockInventory();
    }
    return mockNpcInventory;
  }

  @override
  Future<List<TradeResourceInventory>> getUserInventory(AppUser user) async {
    if (mockUserInventory.isEmpty) {
      mockUserInventory = _generateMockInventory();
    }
    return mockUserInventory;
  }

  @override
  Future<void> updateNpcInventory(Npc npc) {
    mockNpcInventory = npc.inventory;
    return Future.value();
  }

  @override
  Future<void> updateUserInventory(AppUser user) {
    mockUserInventory = user.inventory;
    return Future.value();
  }

  _generateMockInventory() {
    return tradeResourcesList
        .map(
          (tradeResource) => TradeResourceInventory(
            tradeResource: tradeResource,
            defaultProductionLevel: _getRndProductionLevel(),
            defaultNeedLevel: _getRndNeedLevel(),
          ),
        )
        .toList();
  }

  NeedLevel _getRndNeedLevel() {
    final random = generateGaussianRandomNumberInRange(0, 40, 0, 100);
    if (random < 10) {
      return NeedLevel.notInterested;
    } else if (random < 20) {
      return NeedLevel.veryLow;
    } else if (random < 30) {
      return NeedLevel.low;
    } else if (random < 40) {
      return NeedLevel.avarege;
    } else if (random < 50) {
      return NeedLevel.aboveAverage;
    } else if (random < 60) {
      return NeedLevel.substatial;
    } else if (random < 70) {
      return NeedLevel.high;
    } else if (random < 80) {
      return NeedLevel.veryHigh;
    } else if (random < 90) {
      return NeedLevel.direNeed;
    } else {
      return NeedLevel.extremeNeed;
    }
  }

  ProductionLevel _getRndProductionLevel() {
    final random = generateGaussianRandomNumberInRange(0, 40, 0, 100);
    if (random < 10) {
      return ProductionLevel.notProduced;
    } else if (random < 20) {
      return ProductionLevel.veryLow;
    } else if (random < 30) {
      return ProductionLevel.low;
    } else if (random < 40) {
      return ProductionLevel.avarege;
    } else if (random < 50) {
      return ProductionLevel.aboveAverage;
    } else if (random < 60) {
      return ProductionLevel.substatial;
    } else if (random < 70) {
      return ProductionLevel.high;
    } else if (random < 80) {
      return ProductionLevel.veryHigh;
    } else if (random < 90) {
      return ProductionLevel.overProduction;
    } else {
      return ProductionLevel.extremeOverProduction;
    }
  }
}
