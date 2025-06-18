import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  Future<User?> signUp({required String email, required String password});
  Future<User?> logInWithEmailAndPassword({required String email, required String password});
  Future<User?> logInWithGoogle();
  Future<void> logOut();
  Future<User?> getCurrentUser();
  Future<String?> getCurrentUserId();
}