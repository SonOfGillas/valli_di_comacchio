import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

abstract class NpcDataSource {
  Future<Npc> getNpcById(String npc);
  Future<List<Npc>> getAllNpcs();
  Future<void> updateNpcData(Npc npc);
}
