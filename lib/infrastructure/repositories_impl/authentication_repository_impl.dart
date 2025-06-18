import 'package:firebase_auth/firebase_auth.dart';

import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/services_def/authentication_service_def.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationService _authService;
  AuthenticationRepositoryImpl({required AuthenticationService authService}): _authService = authService;

  @override
  Future<User?> signUp({required String email, required String password}) async {
    return await _authService.signUp(email, password);
  }

  @override
  Future<User?> logInWithEmailAndPassword({required String email, required String password}) async {
    return await _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<User?> logInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  @override
  Future<void> logOut() async {
    await _authService.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _authService.getCurrentUser();
  }
  
  @override
  Future<String?> getCurrentUserId() async {
    return _authService.getCurrentUser()?.uid;
  }
}
