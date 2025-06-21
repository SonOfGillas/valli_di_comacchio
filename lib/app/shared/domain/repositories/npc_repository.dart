import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_request.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_response.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class NpcRepository {
  NpcRepository({
    required this.npcDataSource,
    required this.resourcesInventoryDataSource,
    required this.aiGenerationDataSource,
  });
  final NpcDataSource npcDataSource;
  final ResourcesInventoryDataSource resourcesInventoryDataSource;
  final AiGenerationDataSource aiGenerationDataSource;

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

  AsyncResult<CounterOfferResponse> getNpcReponseToCounterOffer(
      CounterOfferRequest counterOfferRequest) async {
    try {
      final response = await aiGenerationDataSource
          .getNpcReponseToCounterOffer(counterOfferRequest);
      return Success(response);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }
}
