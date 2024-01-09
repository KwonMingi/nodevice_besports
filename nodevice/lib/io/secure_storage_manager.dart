

// class SecureStorageManager {
//   final _storage = const FlutterSecureStorage();
//   final encrypt.Key _key;
//   final encrypt.IV _iv;

//   SecureStorageManager({String key = 'BesportsNoDeviceAppExampleKey366'})
//       : _key = encrypt.Key.fromUtf8(key),
//         _iv = encrypt.IV.fromLength(16);

//   String _encrypt(String plainText) {
//     final encrypter = encrypt.Encrypter(encrypt.AES(_key));
//     final encrypted = encrypter.encrypt(plainText, iv: _iv);
//     return encrypted.base64;
//   }

//   String _decrypt(String encryptedText) {
//     final encrypter = encrypt.Encrypter(encrypt.AES(_key));
//     final decrypted =
//         encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedText), iv: _iv);
//     return decrypted;
//   }

//   Future<void> writeSecureData(String key, String value) async {
//     String encryptedValue = _encrypt(value);
//     await _storage.write(key: key, value: encryptedValue);
//   }

//   Future<String?> readSecureData(String key) async {
//     String? encryptedValue = await _storage.read(key: key);
//     return encryptedValue != null ? _decrypt(encryptedValue) : null;
//   }

//   Future<void> deleteSecureData(String key) async {
//     await _storage.delete(key: key);
//   }
// }
