import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_priced.dart';

class Npc extends Equatable {
  const Npc({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.goods,
  });

  final String id;
  final String name;
  final String image;
  final String description;
  final List<TradeResourceOffert> goods;

  // mood -> quando è difficile commerciare quel giorno
  // personality -> quanto è difficile commerciare con quel npc in generale
  // opinion -> opinione del npc sul giocatore

  @override
  List<Object?> get props => [id, name, image, description, goods];
}
