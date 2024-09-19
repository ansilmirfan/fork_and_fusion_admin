import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDataSource {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<void> createAdmin() async {
    try {
      await _secureStorage.write(key: 'user_name', value: 'Ansil Mirfan123');
      await _secureStorage.write(key: 'password', value: 'qwertyuiop123');
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> authenticate(String name, String passWord) async {
    try {
      final userName = await _secureStorage.read(key: 'user_name');
      final password = await _secureStorage.read(key: 'password');
      return name == userName && passWord == password;
    } catch (e) {
      throw e.toString();
    }
  }
}
