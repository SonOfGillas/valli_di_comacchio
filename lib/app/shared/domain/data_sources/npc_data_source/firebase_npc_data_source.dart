import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class FirebaseNpcDataSource extends NpcDataSource {
  FirebaseNpcDataSource(this.cloudFirestoreDataSource);

  final CloudFirestoreDataSource cloudFirestoreDataSource;

  @override
  Future<List<Npc>> getAllNpcs() async {
    final npcCollection =
        await cloudFirestoreDataSource.fetchData(DatabaseCollection.npcs);
    print(npcCollection);
    return [];
  }

  @override
  Future<Npc> getNpcById(String npc) {
    // TODO: implement getNpcById
    throw UnimplementedError();
  }

  @override
  Future<void> updateNpcData(Npc npc) {
    // TODO: implement updateNpcData
    throw UnimplementedError();
  }

  @override
  Future<void> resetNpcs() {
    // TODO: implement resetNpcs
    throw UnimplementedError();
  }
}
