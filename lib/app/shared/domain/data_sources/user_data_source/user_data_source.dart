import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

abstract class UserDataSource {
  Future<AppUser> createUser(String id, String email, String username);
  Future<AppUser> getUserData(String userId);
  Future<void> updateUserData(AppUser user);
}
