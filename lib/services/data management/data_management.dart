import 'package:shared_preferences/shared_preferences.dart';

class DataManagement {
  static Future storeStringData(String key, String value) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(key, value);
  }

  static Future storeIntData(String key, int value) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setInt(key, value);
  }

  static Future getIntData(String key) async {
    final instance = await SharedPreferences.getInstance();
    return instance.getInt(key);
  }

  static Future getStringData(String key) async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(key);
  }

  static Future clear()async{
    final instance = await SharedPreferences.getInstance();
    await instance.clear();
  }
}