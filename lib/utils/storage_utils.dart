import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String?> readStorageKey(String key) async {
  var storage = const FlutterSecureStorage();

  if (await storage.containsKey(key: key)) {
    return storage.read(key: key);
  }
}

Future writeStorageKey(String key, String value) {
  var storage = const FlutterSecureStorage();

  return storage.write(key: key, value: value);
}
