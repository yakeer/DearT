import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
