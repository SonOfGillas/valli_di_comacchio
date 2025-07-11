import 'dart:io';

import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_request.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_response.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quiz.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/talk_to_npc_data.dart';

abstract class AiGenerationDataSource {
  Future<CounterOfferResponse> getNpcReponseToCounterOffer(
      CounterOfferRequest counterOfferRequest);

  Future<File> generateNft();

  Future<Quiz> generateQuiz();

  Future<TalkToNpcData> generateTalkToNpcQuestData(Npc receiverNpc);
}
