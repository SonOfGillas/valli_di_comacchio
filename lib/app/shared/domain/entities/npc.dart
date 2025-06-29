import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class Npc extends Equatable {
  const Npc({
    required this.id,
    required this.name,
    required this.imageLocalPath,
    required this.locationImagePath,
    required this.locationName,
    required this.longitude,
    required this.latitude,
    required this.wealth,
    required this.inventory,
    required this.lastReset,
  });

  final String id;
  final String name;
  final String imageLocalPath;
  final String locationImagePath;
  final String locationName;
  final double longitude;
  final double latitude;
  final int wealth;
  final DateTime lastReset;
  final List<TradeResourceInventory> inventory;

  // mood -> quando è difficile commerciare quel giorno
  // personality -> quanto è difficile commerciare con quel npc in generale
  // opinion -> opinione del npc sul giocatore

  @override
  List<Object?> get props => [
        id,
        name,
        locationImagePath,
        imageLocalPath,
        locationName,
        longitude,
        latitude,
        wealth,
        inventory,
        lastReset,
      ];

  Npc copyWith({
    int? wealth,
    List<TradeResourceInventory>? inventory,
  }) {
    return Npc(
        id: id,
        name: name,
        locationImagePath: locationImagePath,
        locationName: locationName,
        longitude: longitude,
        latitude: latitude,
        imageLocalPath: imageLocalPath,
        wealth: wealth ?? this.wealth,
        inventory: inventory ?? this.inventory,
        lastReset: lastReset);
  }

  factory Npc.fromJson(Map<String, dynamic> json) {
    final invetory = (json['inventory'] as List)
        .map((item) => TradeResourceInventory.fromJson(item))
        .toList();
    return Npc(
      id: json['id'] as String,
      name: json['name'] as String,
      imageLocalPath: json['imageLocalPath'] as String,
      locationImagePath: json['locationImagePath'] as String,
      locationName: json['locationName'] as String,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      wealth: json['wealth'] as int,
      inventory: invetory,
      lastReset: DateTime.parse(
        json['lastReset'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageLocalPath': imageLocalPath,
      'locationImagePath': locationImagePath,
      'locationName': locationName,
      'longitude': longitude,
      'latitude': latitude,
      'wealth': wealth,
      'inventory': inventory.map((item) => item.toJson()).toList(),
      'lastReset': lastReset.toIso8601String(),
    };
  }
}
