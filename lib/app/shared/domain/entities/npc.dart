import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

class Npc extends Equatable {
  const Npc({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.wealth,
    required this.inventory,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final int wealth;
  final List<TradeResourceInventory> inventory;

  // mood -> quando è difficile commerciare quel giorno
  // personality -> quanto è difficile commerciare con quel npc in generale
  // opinion -> opinione del npc sul giocatore

  @override
  List<Object?> get props => [id, name, imageUrl, location, inventory];

  Npc copyWith({
    int? wealth,
    List<TradeResourceInventory>? inventory,
  }) {
    return Npc(
      id: id,
      name: name,
      location: location,
      imageUrl: imageUrl,
      wealth: wealth ?? this.wealth,
      inventory: inventory ?? this.inventory,
    );
  }
}
