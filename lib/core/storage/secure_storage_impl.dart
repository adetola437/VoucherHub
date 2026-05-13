import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage.dart';

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage secureStorage;
  SecureStorageImpl({required this.secureStorage});

  @override
  Future<void> write(String key, String value) =>
      secureStorage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => secureStorage.read(key: key);

  @override
  Future<void> delete(String key) => secureStorage.delete(key: key);

  @override
  Future<void> deleteAll() => secureStorage.deleteAll();
}
