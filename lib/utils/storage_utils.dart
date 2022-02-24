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

  return null;
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

  if (T == double) {
    double? value = prefs.getDouble(keyName);
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

  if (T == double) {
    prefs.setDouble(keyName, value as double);
  }
}

Future<T?> readUserPreference<T>(String keyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (T == bool) {
    bool? value = prefs.getBool(keyName);

    return value as T?;
  }

  if (T == String) {
    String? value = prefs.getString(keyName);

    return value as T?;
  }

  if (T == double) {
    double? value = prefs.getDouble(keyName);

    return value as T?;
  }

  return null;
}

Future writeUserPreference<T>(String prefName, T value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (T == bool) {
    prefs.setBool(prefName, value as bool);
  }

  if (T == double) {
    prefs.setDouble(prefName, value as double);
  }

  if (T == String) {
    prefs.setString(prefName, value as String);
  }
}
