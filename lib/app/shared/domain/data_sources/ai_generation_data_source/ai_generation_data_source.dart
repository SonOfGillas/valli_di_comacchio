import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_request.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_response.dart';

abstract class AiGenerationDataSource {
  Future<CounterOfferResponse> getNpcReponseToCounterOffer(
      CounterOfferRequest counterOfferRequest);

  Future<void> generateRndNft();
}
