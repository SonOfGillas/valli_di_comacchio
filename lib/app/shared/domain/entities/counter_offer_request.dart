import 'package:valli_di_comacchio/app/shared/domain/entities/offer_type.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/past_conversation_entry.dart';

class CounterOfferRequest {
  final String name;
  final String resource; // resource name, e.g., "fish", "grain"
  final OfferType intent;
  final int minPrice;
  final int maxPrice;
  final int targetQuantity;
  final int maxQuantity;
  final int userOfferPrice;
  final int userOfferQuantity;
  final String userMessage;
  final List<PastConversationEntry> pastConversation;

  CounterOfferRequest({
    required this.name,
    required this.resource,
    required this.intent,
    required this.minPrice,
    required this.maxPrice,
    required this.targetQuantity,
    required this.maxQuantity,
    required this.userOfferPrice,
    required this.userOfferQuantity,
    required this.userMessage,
    required this.pastConversation,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'resource': resource,
        'intent': intent == OfferType.buy ? 'buy' : 'sell',
        'min_price': minPrice,
        'max_price': maxPrice,
        'target_quantity': targetQuantity,
        'max_quantity': maxQuantity,
        'user_offer_price': userOfferPrice,
        'user_offer_quantity': userOfferQuantity,
        'user_message': userMessage,
        'past_conversation': pastConversation.map((e) => e.toJson()).toList(),
      };
}
