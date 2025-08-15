import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kEmail = 'auth_email';
  static const _kName = 'auth_name';
  static const _kPassHash = 'auth_password_hash';

  //Has password
  static String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  //create an account (fails if email exist)
  static Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final p = await SharedPreferences.getInstance();
    final existingEmail = p.getString(_kEmail);

    if (existingEmail != null &&
        existingEmail.toLowerCase() == email.toLowerCase()) {
      throw Exception('Account already exist for this email');
    }
    await p.setString(_kName, name.trim());
    await p.setString(_kEmail, email.trim());
    await p.setString(_kPassHash, _hash(password));
  }

  // Login (throws if email not found or password mismatch)
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final p = await SharedPreferences.getInstance();
    final savedEmail = p.getString(_kEmail);
    final savedHash = p.getString(_kPassHash);
    if (savedEmail == null || savedHash == null) {
      throw Exception('No account found. Please Create one.');
    }
    if (savedEmail.toLowerCase() != email.toLowerCase()) {
      throw Exception('Email not fouund');
    }
    if (savedHash != _hash(password)) {
      throw Exception('Incorrect Password.');
    }
  }

  // forgot passwrod - set new one if email matches
  static Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final p = await SharedPreferences.getInstance();
    final savedEmail = p.getString(_kEmail);
    if (savedEmail == null) throw Exception('No account exists.');
    if (savedEmail.toLowerCase() != email.toLowerCase()) {
      throw Exception('Email not found.');
    }
    await p.setString(_kPassHash, _hash(newPassword));
  }

  //Helpers to read profile

  static Future<String?> currentEmail() async =>
      (await SharedPreferences.getInstance()).getString(_kEmail);

  static Future<String?> currentName() async =>
      (await SharedPreferences.getInstance()).getString(_kName);

  // ELS10: Sign out (no real session here, but you may clear later)
  static Future<void> signOut() async {}
}
