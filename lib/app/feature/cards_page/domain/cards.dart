class CollectibleCard {
  int id;
  String name;
  String imagePath;
  int rarity;

  CollectibleCard(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.rarity});

  factory CollectibleCard.fromJson(Map<String, dynamic> json) {
    return CollectibleCard(
      id: json['id'] as int,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      rarity: json['rarity'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'rarity': rarity,
    };
  }
}

final appCardsCompleteList = [
  CollectibleCard(
      id: 1, name: 'Eel', imagePath: 'assets/images/eel_card.png', rarity: 4),
  CollectibleCard(
      id: 2,
      name: 'Eel Foil',
      imagePath: 'assets/images/eel_card_f.png',
      rarity: 5),
  CollectibleCard(
      id: 3,
      name: 'Flamingo',
      imagePath: 'assets/images/flamingo_card.png',
      rarity: 4),
  CollectibleCard(
      id: 4,
      name: 'Flamingo Foil',
      imagePath: 'assets/images/flamingo_card_f.png',
      rarity: 5),
  CollectibleCard(
      id: 5, name: 'Duck', imagePath: 'assets/images/duck_card.png', rarity: 1),
  CollectibleCard(
      id: 6, name: 'Fox', imagePath: 'assets/images/fox_card.png', rarity: 3),
  CollectibleCard(
      id: 7, name: 'Hawk', imagePath: 'assets/images/hawk_card.png', rarity: 3),
  CollectibleCard(
      id: 8,
      name: 'Heron',
      imagePath: 'assets/images/heron_card.png',
      rarity: 2),
  CollectibleCard(
      id: 9,
      name: 'Kingfisher',
      imagePath: 'assets/images/kingfisher_card.png',
      rarity: 2),
  CollectibleCard(
      id: 10,
      name: 'Osprey',
      imagePath: 'assets/images/osprey_card.png',
      rarity: 3),
  CollectibleCard(
      id: 11,
      name: 'Plover',
      imagePath: 'assets/images/plover_card.png',
      rarity: 2),
  CollectibleCard(
      id: 12,
      name: 'Nutria',
      imagePath: 'assets/images/nutria_card.png',
      rarity: 1),
  CollectibleCard(
      id: 13,
      name: 'Frog',
      imagePath: 'assets/images/frog_card.png',
      rarity: 1),
  CollectibleCard(
      id: 14,
      name: 'Seagull',
      imagePath: 'assets/images/seagull_card.png',
      rarity: 1),
  CollectibleCard(
      id: 15,
      name: 'Coot',
      imagePath: 'assets/images/coot_card.png',
      rarity: 1),
  CollectibleCard(
      id: 16,
      name: 'Pheasant',
      imagePath: 'assets/images/pheasant_card.png',
      rarity: 2),
  CollectibleCard(
      id: 17,
      name: 'Goby',
      imagePath: 'assets/images/goby_card.png',
      rarity: 2),
  CollectibleCard(
      id: 18,
      name: 'Mediterranean Killifish',
      imagePath: 'assets/images/mediterranean_killifish_card.png',
      rarity: 2),
  CollectibleCard(
      id: 19,
      name: 'Three-Spined Stickleback',
      imagePath: 'assets/images/three_spined_stickleback_card.png',
      rarity: 2),
];
