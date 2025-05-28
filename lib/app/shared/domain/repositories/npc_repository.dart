import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class NpcRepository {
  NpcRepository({
    required this.npcDataSource,
    required this.resourcesInventoryDataSource,
  });
  final NpcDataSource npcDataSource;
  final ResourcesInventoryDataSource resourcesInventoryDataSource;

  AsyncResult<List<Npc>> getAllNpcs() async {
    return Success([]);
  }

  AsyncResult<Npc> getNpcById(String id) async {
    final npc = await npcDataSource.getNpcById(id);
    final npcInventory =
        await resourcesInventoryDataSource.getNpcInventory(npc);
    return Success(npc.copyWith(
      inventory: npcInventory,
    ));
  }

  AsyncResult<void> updateNpcData(Npc npc) async {
    await npcDataSource.updateNpcData(npc);
    await resourcesInventoryDataSource.updateNpcInventory(npc);
    return Success(null);
  }
}
