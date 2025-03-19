import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService {
  Future<User?> signUp(String email, String password);
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}
