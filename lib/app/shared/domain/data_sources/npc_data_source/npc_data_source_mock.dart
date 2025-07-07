import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/location_information.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

final mockLocationInformation = LocationInformation(
    name: 'Comacchio',
    imagePath: 'https://example.com/test.png',
    description: 'A beautiful location in Comacchio.',
    subLocationsOrActivities: []);

class NpcDataSourceMock implements NpcDataSource {
  var npcDataMock = Npc(
    id: '1',
    name: 'Rosario',
    imageLocalPath: 'https://example.com/test.png',
    locationInformation: mockLocationInformation,
    wealth: 10000,
    inventory: [],
    longitude: 12.3456,
    latitude: 65.4321,
    lastReset: DateTime.now(),
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

  @override
  Future<List<Npc>> resetNpcs() {
    return Future.value([]);
  }
}
