import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class NpcDataSourceMock implements NpcDataSource {
  var npcDataMock = Npc(
    id: '1',
    name: 'Rosario',
    location: 'Comacchio',
    imageUrl: 'https://example.com/test.png',
    wealth: 10000,
    inventory: [],
  );

  @override
  Future<List<Npc>> getAllNpcs() {
    return Future.value([]);
  }

  @override
  Future<Npc> getNpcById(String id) {
    return Future.value(npcDataMock);
  }

  @override
  Future<Npc> updateNpcData(Npc npc) {
    npcDataMock = npc;
    return Future.value(npcDataMock);
  }
}
