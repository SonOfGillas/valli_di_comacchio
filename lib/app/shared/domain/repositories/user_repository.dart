import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/auth_data_source/auth_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

const mockUser = AppUser(
  id: 'mock-id',
  email: 'mock-email@example.com',
  username: 'mock-username',
  inventory: [],
);

class UserRepository {
  UserRepository({
    required this.authDataSource,
    required this.userDataSource,
    required this.resourcesInventoryDataSource,
  });
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;
  final ResourcesInventoryDataSource resourcesInventoryDataSource;

  AsyncResult<bool> isLoggedIn() async {
    try {
      final isLogged = await authDataSource.isLoggedIn();
      return Success(isLogged);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // login
  AsyncResult<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await authDataSource.login(email, password);
      final loggedUser =
          await userDataSource.getUserData(credentials.user!.uid);
      return Success(loggedUser);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // register
  AsyncResult<AppUser> register({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final credentials = await authDataSource.register(
        password,
        email,
      );
      final newUser = await userDataSource.createUser(
        credentials.user!.uid,
        email,
        username,
      );
      return Success(newUser);
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
    // final userInventory =
    //     await resourcesInventoryDataSource.getUserInventory(userData);
    return Success(userData);
  }

  // update user data
  AsyncResult<void> updateUserData(AppUser user) async {
    await userDataSource.updateUserData(user);
    // await resourcesInventoryDataSource.updateUserInventory(user);
    return Success(null);
  }
}
