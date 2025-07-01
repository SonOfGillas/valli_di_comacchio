class CollectibleCard {
  int id;
  String name;
  String imagePath;
  int rarity;

  bool isFoil() {
    return rarity >= 5;
  }

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
      id: 1,
      name: 'Flamingo',
      imagePath: 'assets/images/flamingo_card.jpeg',
      rarity: 4),
  CollectibleCard(
      id: 2,
      name: 'Flamingo Foil',
      imagePath: 'assets/images/flamingo_card_f.jpeg',
      rarity: 6),
  CollectibleCard(
      id: 3, name: 'Eel', imagePath: 'assets/images/eel_card.jpeg', rarity: 4),
  CollectibleCard(
      id: 4,
      name: 'Eel Foil',
      imagePath: 'assets/images/eel_card_f.jpeg',
      rarity: 6),
  CollectibleCard(
      id: 5,
      name: 'Duck',
      imagePath: 'assets/images/duck_card.jpeg',
      rarity: 1),
  CollectibleCard(
      id: 6,
      name: 'Duck Foil',
      imagePath: 'assets/images/duck_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 7, name: 'Fox', imagePath: 'assets/images/fox_card.jpeg', rarity: 3),
  CollectibleCard(
      id: 8,
      name: 'Fox Foil',
      imagePath: 'assets/images/fox_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 9,
      name: 'Hawk',
      imagePath: 'assets/images/hawk_card.jpeg',
      rarity: 3),
  CollectibleCard(
      id: 10,
      name: 'Hawk Foil',
      imagePath: 'assets/images/hawk_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 11,
      name: 'Heron',
      imagePath: 'assets/images/heron_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 12,
      name: 'Heron Foil',
      imagePath: 'assets/images/heron_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 13,
      name: 'Kingfisher',
      imagePath: 'assets/images/kingfisher_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 14,
      name: 'Kingfisher Foil',
      imagePath: 'assets/images/kingfisher_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 15,
      name: 'Osprey',
      imagePath: 'assets/images/osprey_card.jpeg',
      rarity: 3),
  CollectibleCard(
      id: 16,
      name: 'Osprey Foil',
      imagePath: 'assets/images/osprey_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 17,
      name: 'Plover',
      imagePath: 'assets/images/plover_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 18,
      name: 'Plover Foil',
      imagePath: 'assets/images/plover_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 19,
      name: 'Nutria',
      imagePath: 'assets/images/nutria_card.jpeg',
      rarity: 1),
  CollectibleCard(
      id: 20,
      name: 'Nutria Foil',
      imagePath: 'assets/images/nutria_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 21,
      name: 'Frog',
      imagePath: 'assets/images/frog_card.jpeg',
      rarity: 1),
  CollectibleCard(
      id: 22,
      name: 'Frog Foil',
      imagePath: 'assets/images/frog_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 23,
      name: 'Seagull',
      imagePath: 'assets/images/seagull_card.jpeg',
      rarity: 1),
  CollectibleCard(
      id: 24,
      name: 'Seagull Foil',
      imagePath: 'assets/images/seagull_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 25,
      name: 'Coot',
      imagePath: 'assets/images/coot_card.jpeg',
      rarity: 1),
  CollectibleCard(
      id: 26,
      name: 'Coot Foil',
      imagePath: 'assets/images/coot_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 27,
      name: 'Pheasant',
      imagePath: 'assets/images/pheasant_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 28,
      name: 'Pheasant Foil',
      imagePath: 'assets/images/pheasant_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 29,
      name: 'Goby',
      imagePath: 'assets/images/goby_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 30,
      name: 'Goby Foil',
      imagePath: 'assets/images/goby_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 31,
      name: 'Mediterranean Killifish',
      imagePath: 'assets/images/mediterranean_killifish_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 32,
      name: 'Mediterranean Killifish Foil',
      imagePath: 'assets/images/mediterranean_killifish_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 33,
      name: 'Three-Spined Stickleback',
      imagePath: 'assets/images/three_spined_stickleback_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 34,
      name: 'Three-Spined Stickleback Foil',
      imagePath: 'assets/images/three_spined_stickleback_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 35,
      name: 'European pond turtle',
      imagePath: 'assets/images/european_pond_turtle_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 36,
      name: 'European pond turtle Foil',
      imagePath: 'assets/images/european_pond_turtle_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 37,
      name: 'Swan',
      imagePath: 'assets/images/swan_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 38,
      name: 'Swan Foil',
      imagePath: 'assets/images/swan_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 39,
      name: 'Otter',
      imagePath: 'assets/images/otter_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 40,
      name: 'Otter Foil',
      imagePath: 'assets/images/otter_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 41,
      name: 'Grass Snake',
      imagePath: 'assets/images/grass_snake_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 42,
      name: 'Grass Snake Foil',
      imagePath: 'assets/images/grass_snake_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 43,
      name: "sea bass",
      imagePath: 'assets/images/sea_bass_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 44,
      name: 'sea bass Foil',
      imagePath: 'assets/images/sea_bass_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 45,
      name: 'sea bream',
      imagePath: 'assets/images/sea_bream_card.jpeg',
      rarity: 2),
  CollectibleCard(
      id: 46,
      name: 'sea bream Foil',
      imagePath: 'assets/images/sea_bream_card.jpeg',
      rarity: 5),
  CollectibleCard(
      id: 47,
      name: 'deer',
      imagePath: 'assets/images/deer_card.jpeg',
      rarity: 3),
  CollectibleCard(
      id: 48,
      name: 'deer Foil',
      imagePath: 'assets/images/deer_card.jpeg',
      rarity: 5),
];
