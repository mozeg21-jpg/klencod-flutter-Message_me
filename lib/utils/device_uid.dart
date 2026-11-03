import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceUid {
  static const _key = 'device_uid';

  static Future<String> get() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null && saved.isNotEmpty) return saved;
    final info = DeviceInfoPlugin();
    String value;
    try {
      final android = await info.androidInfo;
      value = 'u_${android.id.isEmpty ? android.fingerprint : android.id}';
    } catch (_) {
      value = 'u_${DateTime.now().microsecondsSinceEpoch}';
    }
    await prefs.setString(_key, value);
    return value;
  }
}
