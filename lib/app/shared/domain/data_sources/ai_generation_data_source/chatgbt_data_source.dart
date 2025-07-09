import 'dart:convert';
import 'dart:io';
import 'dart:math';
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

  /**
   curl https://api.openai.com/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
  "model": "gpt-4.1",
  "input": [
    {
      "role": "system",
      "content": [
        {
          "type": "input_text",
          "text": "\n"
        }
      ]
    },
    {
      "role": "user",
      "content": [
        {
          "type": "input_text",
          "text": "Generate a game-like image of a\nFox badge\nStyle: flat, bold lines\nBackground: warm orange\nPose: sitting, tail curled\nAccessory: glasses"
        }
      ]
    },
    {
      "type": "image_generation_call",
      "id": "ig_686e750093b881a2bd727e99e9cc4c6d0e480ceaa422961a"
    },
    {
      "id": "msg_686e750bf6d081a2993b44aca2fcbf670e480ceaa422961a",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "Here is a game-like badge image of a fox in a flat style with bold lines, sitting with its tail curled and wearing glasses, on a warm orange background."
        }
      ]
    }
  ],
  "text": {
    "format": {
      "type": "text"
    }
  },
  "reasoning": {},
  "tools": [
    {
      "type": "image_generation",
      "size": "1024x1024",
      "quality": "low",
      "output_format": "jpeg",
      "background": "auto",
      "moderation": "low",
      "partial_images": 3
    }
  ],
  "temperature": 1,
  "max_output_tokens": 2048,
  "top_p": 1,
  "store": true
}'
   */

  @override
  Future<File> generateRndNft() async {
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
    final animal = randomAnimalList[random.nextInt(randomAnimalList.length)];
    final pose = randomPoseList[random.nextInt(randomPoseList.length)];
    final accessory =
        randomAccessoryList[random.nextInt(randomAccessoryList.length)];
    final expression =
        randomExpressionList[random.nextInt(randomExpressionList.length)];
    final backgroundTheme = randomBackgroundThemeList[
        random.nextInt(randomBackgroundThemeList.length)];

    return 'Generate a game-like image of a\n$animal badge\nStyle: flat, bold lines\nBackground: $backgroundTheme\nPose: $pose\nAccessory: $accessory\nExpression: $expression';
  }
}

const randomAnimalList = [
  'Flamingo',
  'Eel',
  'Duck',
  'Fox',
  'Heron',
  'Hawk',
  'Fish',
  'Crab',
  'Frog',
  'Mussel',
  'Mullet',
  'Shrimp',
  'Turtle',
  'Coot',
  'kingfisher',
  'osprey',
  'pelican',
  'stork',
  'plover',
  'nutria',
  'frog',
  'otter',
  'dragonfly',
  'grasshopper',
  'butterfly',
  'bee',
  'ladybug',
  'snail',
  'Pheasant',
  'turtle',
  'swan',
  'deer',
  'mouse'
];

final randomPoseList = [
  'sitting',
  'standing',
  'lying down',
  'running',
  'jumping',
  'flying',
  'swimming',
  'crawling',
  'hiding',
  'playing',
];

final randomAccessoryList = [
  'glasses',
  'hat',
  'scarf',
  'necklace',
  'bracelet',
  'ring',
  'backpack',
  'watch',
  'earrings',
  'bowtie',
  'flower crown',
  'bandana',
  'sunglasses',
  'headphones',
  'mask',
  'cape',
];

final randomExpressionList = [
  'happy',
  'sad',
  'angry',
  'surprised',
  'confused',
  'excited',
  'bored',
  'curious',
  'playful',
  'calm',
  'serious',
  'thoughtful',
  'proud',
  'nervous',
  'relaxed',
  'content',
  'fearful',
  'amused',
  'embarrassed',
];

final randomBackgroundThemeList = [
  'sunset',
  'sunrise',
  'night sky',
  'rainy day',
  'snowy landscape',
  'autumn leaves',
  'spring flowers',
  'tropical beach',
  'mountain view',
  'desert landscape',
  'forest scene',
  'city skyline',
  'underwater scene',
  'countryside',
  'winter wonderland',
  'starry night',
  'foggy morning',
  'stormy weather',
  'clear blue sky',
  'vibrant sunset',
  'peaceful meadow',
  'lush jungle',
  'rocky coastline',
  'rolling hills',
  'ancient ruins',
  'enchanted forest',
  'mystical cave',
  'futuristic city',
  'fantasy landscape',
  'alien planet',
];
