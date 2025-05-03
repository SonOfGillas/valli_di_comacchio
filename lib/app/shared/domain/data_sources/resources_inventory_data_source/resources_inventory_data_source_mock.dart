import 'dart:math';

import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

class ResourcesInventoryDataSourceMock implements ResourcesInventoryDataSource {
  @override
  Future<List<TradeResourceInventory>> getNpcInventory(Npc npc) async {
    final inventory = tradeResourcesList
        .map(
          (tradeResource) => TradeResourceInventory(
            tradeResource: tradeResource,
            defultPrice: Random().nextInt(100),
            totalQuantity: Random().nextInt(20),
          ),
        )
        .toList();
    return inventory;
  }

  @override
  Future<List<TradeResourceInventory>> getUserInventory(User user) async {
    final inventory = tradeResourcesList
        .map(
          (tradeResource) => TradeResourceInventory(
            tradeResource: tradeResource,
            defultPrice: Random().nextInt(100),
            totalQuantity: Random().nextInt(20),
          ),
        )
        .toList();
    return inventory;
  }
}
