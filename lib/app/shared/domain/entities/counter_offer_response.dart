class CounterOfferResponse {
  final int npcOfferPrice;
  final int npcOfferQuantity;
  final String npcMessage;
  // Indicates that the npc found an anomaly in the trade and wants to stop it.
  final bool stopTheTrade;

  CounterOfferResponse({
    required this.npcOfferPrice,
    required this.npcOfferQuantity,
    required this.npcMessage,
    required this.stopTheTrade,
  });

  factory CounterOfferResponse.fromJson(Map<String, dynamic> json) {
    return CounterOfferResponse(
      npcOfferPrice: json['price'] as int,
      npcOfferQuantity: json['quantity'] as int,
      npcMessage: json['message'] as String,
      stopTheTrade: json['stopTheTrade'] as bool,
    );
  }
}
