import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:valli_di_comacchio/app/shared/core/config/config.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_request.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_response.dart';

class ChatGbtDataSource extends AiGenerationDataSource {
  ChatGbtDataSource({required this.config});

  final Config config;
  static const String model = "gpt-4.1-nano";
  static const String promptId =
      'pmpt_68543f419af88196a0a3684219d9f35b0236302a7c1f8e25';
  static const String promptVersion =
      '13'; // english prompt 10 (outdated), italian prompt 13

  @override
  Future<CounterOfferResponse> getNpcReponseToCounterOffer(
      CounterOfferRequest counterOfferRequest) async {
    final url = Uri.parse('https://api.openai.com/v1/responses');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${config.openaiApiKey}',
    };
    final body = jsonEncode({
      "model": model,
      'prompt': {
        'id': promptId,
        'version': promptVersion,
      },
      'input': [
        {
          'role': 'user',
          'content': jsonEncode(counterOfferRequest.toJson()),
        },
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final output = data['output'] as List<dynamic>?;
      if (output != null && output.isNotEmpty) {
        final content = output[0]['content'] as List<dynamic>?;
        if (content != null && content.isNotEmpty) {
          final responseContent = content[0]['text'] as String?;
          if (responseContent != null) {
            return CounterOfferResponse.fromJson(
              jsonDecode(responseContent),
            );
          }
        }
      }
      throw Exception('Invalid response format: ${response.body}');
    } else {
      throw Exception('Failed to generate response: ${response.body}');
    }
  }
}
