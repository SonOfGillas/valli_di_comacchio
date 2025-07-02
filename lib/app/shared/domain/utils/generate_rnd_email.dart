// generate a random email
import 'dart:math';

String generateRandomEmail() {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  final randomString = List.generate(
      10, (index) => characters[random.nextInt(characters.length)]).join();
  return '$randomString@guest.com';
}
