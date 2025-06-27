import 'package:firebase_auth/firebase_auth.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class AuthDataSource {
  Future<UserCredential> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  Future<UserCredential> register(String password, String email) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    return Future.value();
  }
}
