import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/l10n/app_translations.dart';

class TradeResource extends Equatable {
  const TradeResource({
    required this.id,
    required this.icon,
    required this.name,
  });

  final String id;
  final String icon;
  final String name;

  @override
  List<Object?> get props => [id, icon, name];
}

List<TradeResource> tradeResourcesList = [
  TradeResource(id: '0', icon: '🌷​', name: tr.tradeResourceFlowers),
  TradeResource(id: '1', icon: '​🪵​', name: tr.tradeResourceLogs),
  TradeResource(id: '2', icon: '🌱', name: tr.tradeResourceSeeds),
  TradeResource(id: '3', icon: '🍞', name: tr.tradeResourceBread),
  TradeResource(id: '4', icon: '🍷', name: tr.tradeResourceWine),
  TradeResource(id: '5', icon: '🍯', name: tr.tradeResourceHoney),
  TradeResource(id: '6', icon: '🐟', name: tr.tradeResourceFish),
  TradeResource(id: '7', icon: '🦆', name: tr.tradeResourceBirds),
  TradeResource(id: '8', icon: '🧂', name: tr.tradeResourceSalt),
  TradeResource(id: '9', icon: '🍎', name: tr.tradeResourceFruits),
  TradeResource(id: '10', icon: '🥕', name: tr.tradeResourceVegetable),
  TradeResource(id: '11', icon: '🪰', name: tr.tradeResourceInsects),
  TradeResource(id: '12', icon: '⛵', name: tr.tradeResourceBoot),
  TradeResource(id: '13', icon: '🛠️​', name: tr.tradeResourceTools),
  TradeResource(id: '14', icon: '🏺', name: tr.tradeResourceCeramic),
  TradeResource(id: '15', icon: '🪨', name: tr.tradeResourceStone)
];
