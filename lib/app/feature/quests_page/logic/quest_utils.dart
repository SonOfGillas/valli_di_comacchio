import 'dart:math' as math;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

// function to generate random location between 20 and 100 meters from npc location
GeoPoint generateRandomLocationNearNpc(Npc npc) {
  final random = math.Random();
  final npcLat = npc.latitude;
  final npcLon = npc.longitude;

  // Generate random distance between 20 and 100 meters
  final randomDistance = 20 + (100 - 20) * random.nextDouble();

  // Generate random angle in radians
  final randomAngle = random.nextDouble() * 2 * math.pi;

  // Convert distance from meters to degrees
  // 1 degree latitude ≈ 111,320 meters
  final deltaLat = (randomDistance / 111320) * math.cos(randomAngle);
  final deltaLon =
      (randomDistance / (111320 * math.cos(npcLat * (math.pi / 180)))) *
          math.sin(randomAngle);

  final randomLat = npcLat + deltaLat;
  final randomLon = npcLon + deltaLon;

  return GeoPoint(latitude: randomLat, longitude: randomLon);
}
