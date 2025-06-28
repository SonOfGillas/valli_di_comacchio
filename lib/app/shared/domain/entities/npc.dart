import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class Npc extends Equatable {
  const Npc({
    required this.id,
    required this.name,
    required this.imageName,
    required this.locationName,
    required this.longitude,
    required this.latitude,
    required this.wealth,
    required this.inventory,
  });

  final String id;
  final String name;
  final String imageName;
  final String locationName;
  final double longitude;
  final double latitude;
  final int wealth;
  final List<TradeResourceInventory> inventory;

  // mood -> quando è difficile commerciare quel giorno
  // personality -> quanto è difficile commerciare con quel npc in generale
  // opinion -> opinione del npc sul giocatore

  @override
  List<Object?> get props => [
        id,
        name,
        imageName,
        locationName,
        longitude,
        latitude,
        wealth,
        inventory
      ];

  Npc copyWith({
    int? wealth,
    List<TradeResourceInventory>? inventory,
  }) {
    return Npc(
      id: id,
      name: name,
      locationName: locationName,
      longitude: longitude,
      latitude: latitude,
      imageName: imageName,
      wealth: wealth ?? this.wealth,
      inventory: inventory ?? this.inventory,
    );
  }

  Npc fromJson(String id, Map<String, dynamic> json) {
    return Npc(
      id: id,
      name: json['name'] as String,
      imageName: json['imageName'] as String,
      locationName: json['locationName'] as String,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      wealth: json['wealth'] as int,
      inventory: (json['inventory'] as List)
          .map((item) => TradeResourceInventory.fromJson(item))
          .toList(),
    );
  }
}
