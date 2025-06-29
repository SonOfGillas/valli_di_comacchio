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
    try {
      final npcs = await npcDataSource.getAllNpcs();
      final now = DateTime.now();
      final npcNeedsReset =
          npcs.any((npc) => now.difference(npc.lastReset).inHours >= 1);
      if (npcNeedsReset) {
        final npcs = await npcDataSource.resetNpcs();
        return Success(npcs);
      }
      return Success(npcs);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<Npc> getNpcById(String id) async {
    try {
      final npc = await npcDataSource.getNpcById(id);
      return Success(npc);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<void> updateNpcData(Npc npc) async {
    try {
      await npcDataSource.updateNpcData(npc);
      return Success(null);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
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
