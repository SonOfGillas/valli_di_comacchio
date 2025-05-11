import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    this.inventory = const [],
  });

  final String id;
  final String email;
  final String name;
  final String surname;

  // fama? relazioni npc
  final List<TradeResourceInventory> inventory;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'surname': surname,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
    );
  }

  copyWith({
    List<TradeResourceInventory>? inventory,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      surname: surname,
      inventory: inventory ?? this.inventory,
    );
  }
}
