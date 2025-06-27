import 'package:cloud_firestore/cloud_firestore.dart';

enum DatabaseCollection { users, npcs }

class CloudFirestoreDataSource {
  final db = FirebaseFirestore.instance;

  CloudFirestoreDataSource();

  Future<void> saveData(
      DatabaseCollection collection, Map<String, dynamic> data) async {
    try {
      await db.collection(collection.name).add(data);
    } catch (e) {
      throw Exception('Failed to save data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchData(
      DatabaseCollection collection) async {
    try {
      final snapshot = await db.collection(collection.name).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
