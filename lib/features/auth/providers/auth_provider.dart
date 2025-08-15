import 'package:flutter/material.dart';
import 'package:budget_planner/data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _email;
  String? _name;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;
  String? get name => _name;
  String? get error => _error;

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      _setError(null);
      await AuthService.signUp(name: name, email: email, password: password);
      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _setError(null);
      await AuthService.login(email: email, password: password);
      _email = await AuthService.currentEmail();
      _name = await AuthService.currentName();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      _setError(null);
      await AuthService.resetPassword(email: email, newPassword: newPassword);
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      rethrow;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}
