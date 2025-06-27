import 'package:firebase_auth/firebase_auth.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class AuthDataSource {
  Future<AppUser> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return AppUser(id: '1', email: email, username: 'Test User');
  }

  Future<void> register(String username, String password, String email) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    return Future.value();
  }
}
