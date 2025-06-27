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
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
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
