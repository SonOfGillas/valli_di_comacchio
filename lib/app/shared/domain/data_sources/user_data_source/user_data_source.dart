import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

abstract class UserDataSource {
  Future<User> getUserData(String userId);
}
