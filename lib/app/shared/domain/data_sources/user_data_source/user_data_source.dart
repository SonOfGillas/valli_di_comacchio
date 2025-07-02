import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

abstract class RemoteUserDataSource {
  Future<AppUser> createUser(AppUser user);
  Future<AppUser> getUserData(String userId);
  Future<void> updateUserData(AppUser user);
}

abstract class LocalUserDataSource {
  Future<AppUser?> getUserData();
  Future<AppUser> createUser(String email,
      {String username = 'Ospite', bool isGuest = false});
  Future<void> updateUserData(AppUser user);
  Future<void> deleteUserData();
  Future<void> saveUserPassword(String password);
  Future<String?> getUserPassword();
}
