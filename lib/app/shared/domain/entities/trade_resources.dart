import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/l10n/app_translations.dart';

class TradeResource extends Equatable {
  const TradeResource({
    required this.id,
    required this.icon,
    required this.name,
    required this.basePrice,
    required this.maxNeed,
  });

  final String id;
  final String icon;
  final String name;
  final int basePrice;
  /*
  * maxNeed is the maximum amount of the resource that an NPC can possess 
  */
  final double maxNeed;
  /*
  * maxProduction is the maximum amount of the resource that an NPC can produce
  * it is equal to maxNeed because the NPC can only produce what it needs
  * this is a simplification of the game mechanics
  * in the future, this value can be changed to allow for more complex mechanics
  */
  double get maxProduction => maxNeed;

  @override
  List<Object?> get props => [id, icon, name, basePrice];
}

List<TradeResource> tradeResourcesList = [
  TradeResource(
    id: '0',
    icon: '🌷​',
    name: tr.tradeResourceFlowers,
    basePrice: 50,
    maxNeed: 100,
  ),
  TradeResource(
    id: '1',
    icon: '​🪵​',
    name: tr.tradeResourceLogs,
    basePrice: 30,
    maxNeed: 200,
  ),
  TradeResource(
    id: '2',
    icon: '🌱',
    name: tr.tradeResourceSeeds,
    basePrice: 40,
    maxNeed: 150,
  ),
  TradeResource(
    id: '3',
    icon: '🍞',
    name: tr.tradeResourceBread,
    basePrice: 40,
    maxNeed: 80,
  ),
  TradeResource(
    id: '4',
    icon: '🍷',
    name: tr.tradeResourceWine,
    basePrice: 200,
    maxNeed: 50,
  ),
  TradeResource(
    id: '5',
    icon: '🍯',
    name: tr.tradeResourceHoney,
    basePrice: 60,
    maxNeed: 70,
  ),
  TradeResource(
    id: '6',
    icon: '🐟',
    name: tr.tradeResourceFish,
    basePrice: 70,
    maxNeed: 90,
  ),
  TradeResource(
    id: '7',
    icon: '🦆',
    name: tr.tradeResourceBirds,
    basePrice: 100,
    maxNeed: 40,
  ),
  TradeResource(
    id: '8',
    icon: '🧂',
    name: tr.tradeResourceSalt,
    basePrice: 50,
    maxNeed: 120,
  ),
  TradeResource(
    id: '9',
    icon: '🍎',
    name: tr.tradeResourceFruits,
    basePrice: 60,
    maxNeed: 100,
  ),
  TradeResource(
    id: '10',
    icon: '🥕',
    name: tr.tradeResourceVegetable,
    basePrice: 60,
    maxNeed: 110,
  ),
  TradeResource(
    id: '11',
    icon: '🪰',
    name: tr.tradeResourceInsects,
    basePrice: 20,
    maxNeed: 300,
  ),
  TradeResource(
    id: '12',
    icon: '⛵',
    name: tr.tradeResourceBoot,
    basePrice: 3000,
    maxNeed: 10,
  ),
  TradeResource(
    id: '13',
    icon: '🛠️​',
    name: tr.tradeResourceTools,
    basePrice: 400,
    maxNeed: 40,
  ),
  TradeResource(
    id: '14',
    icon: '🏺',
    name: tr.tradeResourceCeramic,
    basePrice: 150,
    maxNeed: 60,
  ),
  TradeResource(
    id: '15',
    icon: '🪨',
    name: tr.tradeResourceStone,
    basePrice: 10,
    maxNeed: 500,
  ),
];
