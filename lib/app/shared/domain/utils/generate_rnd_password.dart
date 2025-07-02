// generate a random password
import 'dart:math';

String generateRandomPassword() {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random.secure();
  return List.generate(
      12, (index) => characters[random.nextInt(characters.length)]).join();
}
