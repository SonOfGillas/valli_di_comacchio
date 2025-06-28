import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';

class FirebaseUserDataSource extends UserDataSource {
  FirebaseUserDataSource({
    required this.cloudFirestoreDataSource,
  });

  final CloudFirestoreDataSource cloudFirestoreDataSource;

  @override
  Future<AppUser> createUser(String id, String email, String username) async {
    final newUser = AppUser(
      id: id,
      email: email,
      username: username,
      inventory: tradeResourcesList
          .map(
            (resource) => TradeResourceInventory(
              tradeResource: resource,
              defaultProductionLevel: ProductionLevel.notProduced,
              defaultNeedLevel: NeedLevel.notInterested,
              storage: 0,
              needs: 0,
            ),
          )
          .toList(),
      wealth: 500,
    );
    await cloudFirestoreDataSource.addData(
        DatabaseCollection.users, newUser.toJson());
    return Future.value(newUser);
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
