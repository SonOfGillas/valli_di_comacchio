import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceDataSource {
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

  Future<void> deleteCurrentAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw Exception('No user is currently logged in.');
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    return Future.value();
  }
}
