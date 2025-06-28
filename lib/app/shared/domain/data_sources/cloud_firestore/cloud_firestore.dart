import 'package:cloud_firestore/cloud_firestore.dart';

enum DatabaseCollection { users, npcs }

class CloudFirestoreDataSource {
  final db = FirebaseFirestore.instance;

  CloudFirestoreDataSource();

  Future<List<Map<String, dynamic>>> fetchData(
      DatabaseCollection collection) async {
    try {
      final snapshot = await db.collection(collection.name).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> addData(
      DatabaseCollection collection, Map<String, dynamic> data) async {
    try {
      await db.collection(collection.name).add(data);
    } catch (e) {
      throw Exception('Failed to save data: $e');
    }
  }

  Future<void> updateData(DatabaseCollection collection, String docId,
      Map<String, dynamic> data) async {
    try {
      await db.collection(collection.name).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  Future<void> updateAll(DatabaseCollection collection,
      List<Map<String, dynamic>> dataList) async {
    try {
      final batch = db.batch();
      for (var data in dataList) {
        final docRef = db.collection(collection.name).doc(data['id']);
        batch.set(docRef, data);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to update all data: $e');
    }
  }
}
