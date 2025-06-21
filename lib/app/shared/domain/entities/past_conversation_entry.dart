enum ConversationEntity { merchant, user }

extension ConversationEntityExtension on ConversationEntity {
  String toJson() {
    switch (this) {
      case ConversationEntity.merchant:
        return 'Merchant';
      case ConversationEntity.user:
        return 'User';
    }
  }
}

class PastConversationEntry {
  final int order;
  final ConversationEntity entity;
  final String message;
  final int quantity;
  final int price;

  PastConversationEntry({
    required this.order,
    required this.entity,
    required this.message,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'order': order,
        'entity': entity.toJson(),
        'message': message,
        'quantity': quantity,
        'price': price,
      };
}
