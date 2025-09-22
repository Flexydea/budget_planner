import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  // Listen to auth changes
  void init() {
    _authService.authStateChanges.listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> createAccount(
    String email,
    String password,
  ) async {
    await _authService.createAccount(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email: email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
