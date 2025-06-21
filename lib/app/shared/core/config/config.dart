import 'package:flutter_dotenv/flutter_dotenv.dart' as env;

class Config {
  factory Config() {
    return _instance;
  }

  const Config._();

  static const _instance = Config._();

  Future<void> init() async {
    await env.dotenv.load();
    return Future.value();
  }

  String get baseUrl => env.dotenv.get('BASE_URL');
  String get chatGbtApiKey => env.dotenv.get('CHAT_GBT_API_KEY', fallback: '');
}
