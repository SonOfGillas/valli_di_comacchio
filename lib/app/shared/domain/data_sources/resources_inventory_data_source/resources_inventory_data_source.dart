import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

abstract class ResourcesInventoryDataSource {
  Future<List<TradeResourceInventory>> getNpcInventory(Npc npc);
  Future<void> updateNpcInventory(Npc npc);
  Future<List<TradeResourceInventory>> getUserInventory(User user);
  Future<void> updateUserInventory(User user);
}
