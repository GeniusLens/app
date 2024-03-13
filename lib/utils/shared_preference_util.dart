import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  // 使用单例模式创建一个实例
  static final SharedPreferenceUtil _instance =
      SharedPreferenceUtil._internal();

  factory SharedPreferenceUtil() => _instance;

  SharedPreferenceUtil._internal();

  // 保存数据
  Future<bool> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      return prefs.setString(key, value);
    }
    if (value is int) {
      return prefs.setInt(key, value);
    }
    if (value is double) {
      return prefs.setDouble(key, value);
    }
    if (value is bool) {
      return prefs.setBool(key, value);
    }
    if (value is List<String>) {
      return prefs.setStringList(key, value);
    }
    return false;
  }

  // 获取数据
  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}
