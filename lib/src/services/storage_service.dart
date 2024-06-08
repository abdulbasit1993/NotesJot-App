import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> saveToLocal(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String> getFromLocal(String key) async {
    return await secureStorage.read(key: key) ?? "";
  }
}
