import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/auth_data_source/auth_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class UserRepository {
  UserRepository({
    required this.authDataSource,
    required this.userDataSource,
    required this.resourcesInventoryDataSource,
  });
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;
  final ResourcesInventoryDataSource resourcesInventoryDataSource;

  // login
  AsyncResult<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      return Success(await authDataSource.login(email, password));
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // register
  AsyncResult<void> register({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      return Success(await authDataSource.register(username, password, email));
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // logout
  AsyncResult<void> logout() async {
    return Success(null);
  }

  // get user data
  AsyncResult<AppUser> getUserData(String userId) async {
    final userData = await userDataSource.getUserData(userId);
    final userInventory =
        await resourcesInventoryDataSource.getUserInventory(userData);
    return Success(userData.copyWith(
      inventory: userInventory,
    ));
  }

  // update user data
  AsyncResult<void> updateUserData(AppUser user) async {
    await userDataSource.updateUserData(user);
    await resourcesInventoryDataSource.updateUserInventory(user);
    return Success(null);
  }
}
