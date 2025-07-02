import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class FirebaseUserDataSource extends RemoteUserDataSource {
  FirebaseUserDataSource({
    required this.cloudFirestoreDataSource,
  });

  final CloudFirestoreDataSource cloudFirestoreDataSource;

  @override
  Future<AppUser> createUser(AppUser user) async {
    await cloudFirestoreDataSource.addData(
        DatabaseCollection.users, user.toJson());
    return Future.value(user);
  }

  @override
  Future<AppUser> getUserData(String userId) async {
    final userCollection =
        await cloudFirestoreDataSource.fetchData(DatabaseCollection.users);
    final userData = userCollection
        .map((data) => AppUser.fromJson(data))
        .firstWhere((user) => user.id == userId);
    return userData;
  }

  @override
  Future<void> updateUserData(AppUser user) async {
    await cloudFirestoreDataSource.updateData(
        DatabaseCollection.users, user.id, user.toJson());
  }
}
