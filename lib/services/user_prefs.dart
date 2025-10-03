import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Saves the username for the currently logged-in user
Future<void> saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid != null) {
    await prefs.setString("user_name_$uid", name);
  }
}

// Loads the username for the currently logged-in user
Future<String> loadUserName() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid != null) {
    return prefs.getString("user_name_$uid") ?? "User";
  }
  return "User";
}
