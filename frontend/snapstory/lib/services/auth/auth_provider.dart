import 'package:snapstory/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String userName,
    required String password,
  });

  Future<void> logout();

  Future<void> deleteUser({required String email, required String password});

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetEmail({required String email});
}
