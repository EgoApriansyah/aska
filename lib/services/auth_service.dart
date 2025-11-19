import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<User?> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // SIGN UP
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Sign up error: $e");
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
