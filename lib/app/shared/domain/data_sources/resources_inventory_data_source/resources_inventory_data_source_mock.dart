import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_reset_data.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class ResourcesInventoryDataSourceMock implements ResourcesInventoryDataSource {
  var mockUserInventory = <TradeResourceInventory>[];
  var mockNpcInventory = <TradeResourceInventory>[];

  @override
  Future<List<TradeResourceInventory>> getNpcInventory(Npc npc) async {
    if (mockNpcInventory.isEmpty) {
      mockNpcInventory = generateRndInventory();
    }
    return mockNpcInventory;
  }

  @override
  Future<List<TradeResourceInventory>> getUserInventory(AppUser user) async {
    if (mockUserInventory.isEmpty) {
      mockUserInventory = generateRndInventory();
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
}
