import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    this.inventory = const [],
    this.wealth = 0,
  });

  final String id;
  final String email;
  final String username;
  /*
  * wealth is the amount of game-money the user has
  */
  final int wealth;

  // fama? relazioni npc
  final List<TradeResourceInventory> inventory;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'wealth': wealth,
        'inventory': inventory.map((item) => item.toJson()).toList(),
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final inventoryList = json['inventory'] as List<dynamic>?;
    final inventory = inventoryList != null
        ? inventoryList
            .map((item) =>
                TradeResourceInventory.fromJson(item as Map<String, dynamic>))
            .toList()
        : <TradeResourceInventory>[];
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      wealth: json['wealth'] as int? ?? 0,
      inventory: inventory,
    );
  }

  copyWith({
    List<TradeResourceInventory>? inventory,
    int? wealth,
  }) {
    return AppUser(
      id: id,
      email: email,
      username: username,
      inventory: inventory ?? this.inventory,
      wealth: wealth ?? this.wealth,
    );
  }
}
