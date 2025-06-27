import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class UserDataSourceMock implements UserDataSource {
  var mockUser = AppUser(
    id: '00000000-0000-0000-0000-000000000001',
    email: 'John.Doe@gmail.com',
    username: 'John',
    inventory: [],
    wealth: 10000,
  );

  @override
  Future<AppUser> getUserData(String userId) async {
    return Future.value(mockUser);
  }

  @override
  Future<void> updateUserData(AppUser user) {
    mockUser = user;
    return Future.value();
  }
}
