import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

class UserDataSourceMock implements UserDataSource {
  var mockUser = User(
    id: '00000000-0000-0000-0000-000000000001',
    email: 'John.Doe@gmail.com',
    name: 'John',
    surname: 'Doe',
    inventory: [],
    wealth: 1000,
  );

  @override
  Future<User> getUserData(String userId) async {
    return Future.value(mockUser);
  }

  @override
  Future<void> updateUserData(User user) {
    mockUser = user;
    return Future.value();
  }
}
