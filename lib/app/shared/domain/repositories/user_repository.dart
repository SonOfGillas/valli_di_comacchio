import 'dart:math';

import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/auth_data_source/auth_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/generate_rnd_email.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/generate_rnd_password.dart';

class UserRepository {
  UserRepository({
    required this.authDataSource,
    required this.remoteUserDataSource,
    required this.localUserDataSource,
  });
  final AuthServiceDataSource authDataSource;
  final RemoteUserDataSource remoteUserDataSource;
  final LocalUserDataSource localUserDataSource;

  // remote login
  AsyncResult<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await authDataSource.login(email, password);
      final loggedUser =
          await remoteUserDataSource.getUserData(credentials.user!.uid);
      // save the logged user data locally
      await localUserDataSource.updateUserData(loggedUser);
      await localUserDataSource.saveUserPassword(password);
      return Success(loggedUser);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // autologin: try to login with the local user data
  AsyncResult<AppUser> autoLogin() async {
    try {
      final localUser = await localUserDataSource.getUserData();
      final localUserPassword = await localUserDataSource.getUserPassword();
      if (localUser == null || localUserPassword == null) {
        return Error(Failure.fromMessage('login failed: no local user data'));
      }
      if (localUser.isGuest) {
        await authDataSource.login(localUser.email, localUserPassword);
        return Success(localUser);
      } else {
        final loginResponse =
            await login(email: localUser.email, password: localUserPassword);
        AppUser? remoteUser;
        loginResponse.fold(
          onSuccess: (user) {
            remoteUser = user;
          },
        );
        if (remoteUser == null) {
          return Error(Failure.fromMessage('remote user not found'));
        } else {
          return Success(remoteUser!);
        }
      }
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // a password and an email are required to access the db
  AsyncResult<AppUser> createLocalUser({
    required bool isGuest,
    String? email,
    String? username,
    String? password,
  }) async {
    try {
      final userPassword = password ?? generateRandomPassword();
      final userEmail = email ?? generateRandomEmail();

      await localUserDataSource.saveUserPassword(userPassword);
      final newUser = await localUserDataSource.createUser(
        userEmail,
        username: username ?? 'Ospite',
        isGuest: isGuest,
      );

      // all users need registration to the auth service to access the database
      await authDataSource.register(
        userPassword,
        userEmail,
      );
      return Success(newUser);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // create a remote user (connected to the database and authentication service) and also saved locally
  AsyncResult<AppUser> register({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final userCreationResponse = await createLocalUser(
        isGuest: false,
        email: email,
        username: username,
        password: password,
      );
      AppUser? newUser;
      userCreationResponse.fold(onSuccess: (user) async {
        newUser = user;
      });
      if (newUser != null) {
        final newRemoteUser = await remoteUserDataSource.createUser(newUser!);
        return Success(newRemoteUser);
      } else {
        return Error(Failure.fromMessage('User creation failed'));
      }
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // add a guest user to the remote database
  AsyncResult<AppUser> addGuestUserToRemote({
    required String email,
    required String username,
    required String password,
    required AppUser localUser,
  }) async {
    try {
      await localUserDataSource.saveUserPassword(password);
      // remove the guest credential form the authentication service
      // and register the new user with the provided email and password
      await authDataSource.deleteCurrentAccount();
      await authDataSource.register(
        password,
        email,
      );
      final newUser = AppUser(
        id: email,
        email: email,
        username: username,
        inventory: localUser.inventory,
        cardCollection: localUser.cardCollection,
        isGuest: false,
        wealth: localUser.wealth,
      );
      await localUserDataSource.updateUserData(newUser);
      final newRemoteUser = await remoteUserDataSource.createUser(newUser);
      return Success(newRemoteUser);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // logout
  AsyncResult<void> logout({required bool isGuest}) async {
    try {
      await localUserDataSource.deleteUserData();
      if (isGuest) {
        // if the guest logout it will lose all the data
        await authDataSource.deleteCurrentAccount();
        return Success(null);
      } else {
        await authDataSource.logout();
        return Success(null);
      }
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // get user data
  AsyncResult<AppUser> getUserData(
      {required bool isGuest, required String userId}) async {
    try {
      if (isGuest) {
        final guestUser = await localUserDataSource.getUserData();
        if (guestUser == null) {
          return Error(Failure.fromMessage('no local guest user'));
        }
        return Success(guestUser);
      } else {
        final userData = await remoteUserDataSource.getUserData(userId);
        return Success(userData);
      }
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  // update user data
  AsyncResult<void> updateUserData({required AppUser user}) async {
    try {
      await localUserDataSource.updateUserData(user);
      if (user.isGuest) {
        return Success(null);
      } else {
        await remoteUserDataSource.updateUserData(user);
        return Success(null);
      }
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }
}
