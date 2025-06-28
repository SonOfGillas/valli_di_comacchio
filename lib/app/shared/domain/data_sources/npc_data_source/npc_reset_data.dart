// npc names
// rosario
// eelena
// pino
// al carpone
// qua qua

import 'dart:math';

import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

/// Generate a random wealth value for NPCs.
/// the value should be between 3000 and 20000
int generateRandomWealth() {
  return Random().nextInt(17000) + 3000;
}

List<Npc> npcResetData = [
  Npc(
    id: 'npc_1',
    name: 'Rosario',
    imageName: 'rosario.png',
    locationName: 'Via dei Bilancioni',
    longitude: 12.197045,
    latitude: 44.672905,
    wealth: generateRandomWealth(),
    inventory: [],
  ),
  Npc(
    id: 'npc_2',
    name: 'Eelena',
    imageName: 'eelena.png',
    locationName: 'Ponte dei Trepponti',
    longitude: 12.183259,
    latitude: 44.693005,
    wealth: generateRandomWealth(),
    inventory: [],
  ),
  Npc(
    id: 'npc_3',
    name: 'Pino',
    imageName: 'pino.png',
    locationName: 'Lido di Spina',
    longitude: 12.252110,
    latitude: 44.653382,
    wealth: generateRandomWealth(),
    inventory: [],
  ),
  Npc(
    id: 'npc_4',
    name: 'Al Carpone',
    imageName: 'npc_4.png',
    locationName: 'Lido degli Estensi',
    longitude: 12.247454,
    latitude: 44.669262,
    wealth: generateRandomWealth(),
    inventory: [],
  ),
  Npc(
    id: 'npc_5',
    name: 'Qua Qua',
    imageName: 'npc_5.png',
    locationName: 'Porto Garibaldi',
    longitude: 12.243106,
    latitude: 44.678690,
    wealth: generateRandomWealth(),
    inventory: [],
  ),
];
