import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:valli_di_comacchio/app/shared/core/config/config.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/nft_random_generation_data.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_request.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_response.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quiz.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/talk_to_npc_data.dart';

class ChatGbtDataSource extends AiGenerationDataSource {
  ChatGbtDataSource({required this.config});

  final Config config;
  static const String model = "gpt-4.1-nano";

  @override
  Future<CounterOfferResponse> getNpcReponseToCounterOffer(
      CounterOfferRequest counterOfferRequest) async {
    const String promptId =
        'pmpt_68543f419af88196a0a3684219d9f35b0236302a7c1f8e25';
    const String promptVersion =
        '13'; // english prompt 10 (outdated), italian prompt 13
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

  @override
  Future<File> generateNft() async {
    // Mock implementation for generating a random NFT image.
    File mockFile = File('assets/images/fox.png');
    return mockFile;

    // REAL IMPLEMENTATION
    // Real implementation is expensive so it is commented out for tests
    // ignore: dead_code
    try {
      final url = Uri.parse('https://api.openai.com/v1/images/generations');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${config.openaiApiKey}',
      };
      final body = jsonEncode({
        "prompt": getRandNftPrompt(),
        "n": 1,
        "size": "1024x1024",
        "response_format": "b64_json"
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageData = data['data'][0]['b64_json'] as String;

        // You can decode and save the image like this:
        final bytes = base64Decode(imageData);
        final file = File(
            'path/to/save/nft_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception('Failed to generate NFT: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate random NFT: $e');
    }
  }

  String getRandNftPrompt() {
    Random random = Random();
    final animal =
        nftRandomAnimalList[random.nextInt(nftRandomAnimalList.length)];
    final pose = nftRandomPoseList[random.nextInt(nftRandomPoseList.length)];
    final accessory =
        nftRandomAccessoryList[random.nextInt(nftRandomAccessoryList.length)];
    final expression =
        nftRandomExpressionList[random.nextInt(nftRandomExpressionList.length)];
    final backgroundTheme = nftRandomBackgroundThemeList[
        random.nextInt(nftRandomBackgroundThemeList.length)];

    return 'Generate a game-like image of a\n$animal badge\nStyle: flat, bold lines\nBackground: $backgroundTheme\nPose: $pose\nAccessory: $accessory\nExpression: $expression';
  }

  @override
  Future<Quiz> generateQuiz() async {
    const String promptId =
        'pmpt_686fbcac65208193b69ddba9e526ab050622512d49c3be74';
    const String version = '1';
    final url = Uri.parse('https://api.openai.com/v1/responses');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${config.openaiApiKey}',
    };
    final randomTheme =
        listOfQuizThemes[Random().nextInt(listOfQuizThemes.length)];
    final body = jsonEncode({
      "model": model,
      'prompt': {
        'id': promptId,
        'version': version,
      },
      'input': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'input_text',
              'text': QuizInput(
                theme: randomTheme,
              ).toJson().toString(),
            }
          ],
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
            return Quiz.fromJson(
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

  @override
  Future<TalkToNpcData> generateTalkToNpcQuestData(Npc receiverNpc) async {
    const String promptId =
        'pmpt_686f85b84f5c8190a3ef9abffe65ecd60a18825d73558b64';
    const String version = '1';
    final url = Uri.parse('https://api.openai.com/v1/responses');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${config.openaiApiKey}',
    };
    final randomTheme =
        listOfTalkToNpcThemes[Random().nextInt(listOfTalkToNpcThemes.length)];
    final body = jsonEncode({
      "model": model,
      'prompt': {
        'id': promptId,
        'version': version,
      },
      'input': [
        {
          'role': 'user',
          'content': {
            "npc_name": receiverNpc.name,
            "theme": randomTheme,
            "subTheme": randomTheme.randomSubTheme,
          },
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
            return TalkToNpcData.fromJson(
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

class QuizInput {
  QuizInput({
    required this.theme,
  });

  final String theme;

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
    };
  }

  factory QuizInput.fromJson(Map<String, dynamic> json) {
    return QuizInput(
      theme: json['theme'] as String,
    );
  }
}
