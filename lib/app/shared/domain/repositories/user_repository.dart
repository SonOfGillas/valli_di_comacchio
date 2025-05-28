import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

class UserRepository {
  UserRepository({
    required this.userDataSource,
    required this.resourcesInventoryDataSource,
  });
  final UserDataSource userDataSource;
  final ResourcesInventoryDataSource resourcesInventoryDataSource;

  // login
  AsyncResult<void> login({
    required String username,
    required String password,
  }) async {
    return Success(null);
  }

  // register
  AsyncResult<void> register({
    required String username,
    required String password,
    required String email,
  }) async {
    return Success(null);
  }

  // logout
  AsyncResult<void> logout() async {
    return Success(null);
  }

  // get user data
  AsyncResult<User> getUserData(String userId) async {
    final userData = await userDataSource.getUserData(userId);
    final userInventory =
        await resourcesInventoryDataSource.getUserInventory(userData);
    return Success(userData.copyWith(
      inventory: userInventory,
    ));
  }

  // update user data
  AsyncResult<void> updateUserData(User user) async {
    await userDataSource.updateUserData(user);
    await resourcesInventoryDataSource.updateUserInventory(user);
    return Success(null);
  }
}
