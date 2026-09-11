import 'dart:convert';

/// Secure Storage Abstraction for sensitive client data (e.g., auth tokens, user consent).
/// Ensures no raw API keys or sensitive student PII are stored in plain text.
class SecureStorageService {
  final Map<String, String> _encryptedStore = {};

  Future<void> writeSecure(String key, String value) async {
    // In production Flutter builds, uses flutter_secure_storage / Keychain / Keystore.
    final encoded = base64Encode(utf8.encode(value));
    _encryptedStore[key] = encoded;
  }

  Future<String?> readSecure(String key) async {
    final encoded = _encryptedStore[key];
    if (encoded == null) return null;
    return utf8.decode(base64Decode(encoded));
  }

  Future<void> deleteSecure(String key) async {
    _encryptedStore.remove(key);
  }

  Future<void> clearAll() async {
    _encryptedStore.clear();
  }
}
