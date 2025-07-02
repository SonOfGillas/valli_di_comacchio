import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    this.inventory = const <TradeResourceInventory>[],
    this.cardCollection = const <CollectibleCard>{},
    this.wealth = 0,
    this.isGuest = false,
  });

  final String id;
  final String email;
  final String username;
  /*
  * wealth is the amount of game-money the user has
  */
  final int wealth;

  final List<TradeResourceInventory> inventory;
  final Set<CollectibleCard> cardCollection;
  /* Guest is a local user not connected to the database */
  final bool isGuest;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'wealth': wealth,
        'inventory': inventory.map((item) => item.toJson()).toList(),
        'cardCollection':
            cardCollection.toList().map((card) => card.toJson()).toList(),
        'isGuest': isGuest,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final inventoryList = json['inventory'] as List<dynamic>?;
    final inventory = inventoryList != null
        ? inventoryList
            .map((item) =>
                TradeResourceInventory.fromJson(item as Map<String, dynamic>))
            .toList()
        : <TradeResourceInventory>[];
    final cardCollectionList = json['cardCollection'] as List<dynamic>?;
    final cardCollection = cardCollectionList != null
        ? cardCollectionList
            .map((item) =>
                CollectibleCard.fromJson(item as Map<String, dynamic>))
            .toList()
        : <CollectibleCard>[];
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      wealth: json['wealth'] as int? ?? 0,
      inventory: inventory,
      cardCollection: cardCollection.toSet(),
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  copyWith({
    List<TradeResourceInventory>? inventory,
    Set<CollectibleCard>? cardCollection,
    int? wealth,
  }) {
    return AppUser(
      id: id,
      email: email,
      username: username,
      inventory: inventory ?? this.inventory,
      wealth: wealth ?? this.wealth,
      cardCollection: cardCollection ?? this.cardCollection,
      isGuest: isGuest,
    );
  }
}
