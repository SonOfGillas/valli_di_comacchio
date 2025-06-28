import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_reset_data.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class FirebaseNpcDataSource extends NpcDataSource {
  FirebaseNpcDataSource({required this.cloudFirestoreDataSource});

  final CloudFirestoreDataSource cloudFirestoreDataSource;

  @override
  Future<List<Npc>> getAllNpcs() async {
    final npcCollection =
        await cloudFirestoreDataSource.fetchData(DatabaseCollection.npcs);
    return npcCollection.map((data) => Npc.fromJson(data)).toList();
  }

  @override
  Future<Npc> getNpcById(String id) async {
    final npcCollection =
        await cloudFirestoreDataSource.fetchData(DatabaseCollection.npcs);
    return npcCollection.map((data) => Npc.fromJson(data)).firstWhere(
          (npc) => npc.id == id,
          orElse: () => throw Exception('NPC not found'),
        );
  }

  @override
  Future<void> updateNpcData(Npc npc) {
    return cloudFirestoreDataSource.updateData(
        DatabaseCollection.npcs, npc.id, npc.toJson());
  }

  @override
  Future<List<Npc>> resetNpcs() async {
    final List<Npc> npcList = generateNpcResetData();
    final npcListJson = npcList.map((npc) => npc.toJson()).toList();
    await cloudFirestoreDataSource.updateAll(
        DatabaseCollection.npcs, npcListJson);
    return Future.value(npcList);
  }
}
