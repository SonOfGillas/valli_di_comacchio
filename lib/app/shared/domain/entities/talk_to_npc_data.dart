import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class NpcItem {
  final String itemName;
  final bool isFound;

  NpcItem({required this.itemName, this.isFound = false});

  factory NpcItem.fromJson(Map<String, dynamic> json) {
    return NpcItem(
      itemName: json['itemName'] as String,
      isFound: json['isFound'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'isFound': isFound,
    };
  }
}

class QuestItem extends NpcItem with EquatableMixin {
  final GeoPoint itemLocation;

  QuestItem({
    required super.itemName,
    required super.isFound,
    required this.itemLocation,
  });

  @override
  List<Object?> get props => [itemName, itemLocation, isFound];

  copyWith({
    bool? isFound,
  }) {
    return QuestItem(
      itemName: itemName,
      itemLocation: itemLocation,
      isFound: isFound ?? this.isFound,
    );
  }
}

class TalkToNpcData {
  final String message;
  final List<NpcItem> itemList;

  TalkToNpcData({required this.message, required this.itemList});

  factory TalkToNpcData.fromJson(Map<String, dynamic> json) {
    return TalkToNpcData(
      message: json['message'] as String,
      itemList: (json['itemList'] as List)
          .map((item) => NpcItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'itemList': itemList.map((item) => item.toJson()).toList(),
    };
  }
}

class TalkToNpcTheme {
  final String themeName;
  final List<String> subThemes;

  TalkToNpcTheme({required this.themeName, required this.subThemes});

  get randomSubTheme {
    if (subThemes.isEmpty) {
      return '';
    }
    final randomIndex = Random().nextInt(subThemes.length);
    return subThemes[randomIndex];
  }
}

final listOfTalkToNpcThemes = [
  TalkToNpcTheme(
    themeName: 'Escursione',
    subThemes: [
      'passeggiata',
      'giro in barca',
      'giro in bicicletta',
      'giro in canoa',
      'giro in kayak',
      'giro in moto',
      'giro in auto',
    ],
  ),
  TalkToNpcTheme(
    themeName: 'Cultura',
    subThemes: [
      'storia',
      'arte',
      'architettura',
      'tradizioni locali',
      'cucina tipica',
      'eventi culturali',
    ],
  ),
  TalkToNpcTheme(
    themeName: 'Natura',
    subThemes: [
      'fenicotteri',
      'anguille',
      'pesci',
      'uccelli migratori',
      'piante tipiche',
      'ecosistemi',
      'fauna selvatica',
    ],
  ),
  TalkToNpcTheme(
    themeName: 'Attività',
    subThemes: [
      'pesca',
      'birdwatching',
      'fotografia',
      'osservazione della fauna',
      'sport acquatici',
      'escursionismo',
      'ciclismo',
    ],
  ),
  TalkToNpcTheme(
    themeName: 'Spiagge',
    subThemes: [
      'spiaggia libera',
      'stabilimento balneare',
      'attività in spiaggia',
      'sport da spiaggia',
      'relax in spiaggia',
      'eventi in spiaggia',
    ],
  ),
];
