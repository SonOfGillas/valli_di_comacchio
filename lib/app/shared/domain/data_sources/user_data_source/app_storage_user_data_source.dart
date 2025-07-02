import 'dart:convert';

import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class AppStorageUserDataSource extends LocalUserDataSource {
  AppStorageUserDataSource(this.appStorage);

  final AppStorage appStorage;

  @override
  Future<AppUser?> getUserData() async {
    final user = await appStorage.read(key: AppStorage.userKey);
    if (user != null) {
      final localUserData = AppUser.fromJson(jsonDecode(user));
      return localUserData;
    } else {
      return null;
    }
  }

  @override
  Future<String?> getUserPassword() async {
    return await appStorage.read(key: AppStorage.userPasswordKey);
  }

  @override
  Future<void> updateUserData(AppUser user) async {
    await appStorage.write(
      key: AppStorage.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> deleteUserData() async {
    await appStorage.delete(key: AppStorage.userKey);
    await appStorage.delete(key: AppStorage.userPasswordKey);
  }

  // create and user and save it to local storage
  @override
  Future<AppUser> createUser(String email,
      {String username = 'Ospite', bool isGuest = false}) async {
    final newUser = AppUser(
      id: email,
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
      cardCollection: const [],
      isGuest: isGuest,
      wealth: 10000,
    );
    await appStorage.write(
      key: AppStorage.userKey,
      value: jsonEncode(newUser.toJson()),
    );
    return Future.value(newUser);
  }

  @override
  Future<void> saveUserPassword(String password) {
    return appStorage.write(
      key: AppStorage.userPasswordKey,
      value: password,
    );
  }
}
