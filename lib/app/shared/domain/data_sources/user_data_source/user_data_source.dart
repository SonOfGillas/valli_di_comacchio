import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

abstract class UserDataSource {
  Future<AppUser> getUserData(String userId);
  Future<void> updateUserData(AppUser user);
}
