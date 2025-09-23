import '../main.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

  Future<void> deleteAccount(
    String email,
    String password,
  ) async {
    await _authService.deleteAccount(
      email: email,
      password: password,
    );
    _user = null; // reset locally
    notifyListeners();
  }

  //deleting google account
  Future<void> deleteGoogleAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No user signed in");

    if (user.providerData.first.providerId !=
        "google.com") {
      throw Exception(
        "This account is not a Google account.",
      );
    }

    // Reauthenticate with Google
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null)
      throw Exception("Google sign-in canceled.");

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);
    await user.delete();
    await FirebaseAuth.instance.signOut();
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser =
        await googleSignIn.signIn();

    if (googleUser == null) return; // user cancelled

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
  }

  // IOS apple sign in
  // Future<void> signInWithApple() async {
  //   final appleCredential =
  //       await SignInWithApple.getAppleIDCredential(
  //         scopes: [
  //           AppleIDAuthorizationScopes.email,
  //           AppleIDAuthorizationScopes.fullName,
  //         ],
  //       );

  //   final oauthCredential = OAuthProvider("apple.com")
  //       .credential(
  //         idToken: appleCredential.identityToken,
  //         accessToken: appleCredential.authorizationCode,
  //       );

  //   await FirebaseAuth.instance.signInWithCredential(
  //     oauthCredential,
  //   );
  // }
}
