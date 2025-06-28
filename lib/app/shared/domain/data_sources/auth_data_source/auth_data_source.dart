import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  Future<bool> isLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

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
