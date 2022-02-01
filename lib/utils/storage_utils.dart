import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> containsStorageKey(String key) {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  return storage.containsKey(key: key);
}

Future<String?> readStorageKey(String key) async {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  if (await storage.containsKey(key: key)) {
    return storage.read(key: key);
  }
}

Future writeStorageKey(String key, String value) {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  return storage.write(key: key, value: value);
}

Future deleteStorageKey(String key) {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  return storage.delete(key: key);
}

Future<T> readPreference<T>(
    int vehicleId, String prefName, T defaultValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String keyName = 'v$vehicleId-$prefName';
  if (T == bool) {
    bool? value = prefs.getBool(keyName);
    if (value == null) {
      await writePreference(vehicleId, prefName, defaultValue);
      return defaultValue;
    } else {
      return Future.value(value) as Future<T>;
    }
  }

  throw 'Non implemented';
}

Future writePreference<T>(int vehicleId, String prefName, T value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String keyName = 'v$vehicleId-$prefName';
  if (T == bool) {
    prefs.setBool(keyName, value as bool);
  }
}
