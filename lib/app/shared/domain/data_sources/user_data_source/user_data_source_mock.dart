import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

class UserDataSourceMock implements UserDataSource {
  @override
  Future<User> getUserData(String userId) async {
    return User(
      id: '00000000-0000-0000-0000-000000000001',
      email: 'John.Doe@gmail.com',
      name: 'John',
      surname: 'Doe',
      inventory: [],
    );
  }
}
