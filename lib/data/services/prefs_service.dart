import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _kOnboarded = 'hasOnboarded';

  //has the user completed onboarding?

  static Future<bool> get hasOnboarded async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kOnboarded) ?? false;
  }

  //onboarding complete
  static Future<void> setOnboarded() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kOnboarded, true);
  }
}
