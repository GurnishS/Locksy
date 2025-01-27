import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart'; // Add this to generate unique IDs

class CryptographyHandler {
  CryptographyHandler._();

  static final CryptographyHandler getInstance = CryptographyHandler._();

  String? _masterKey;
  SharedPreferences? _prefs;

  Future<void> _initializePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> getMasterKey() async {
    await _initializePrefs();
    final String? masterPass = _prefs?.getString('master-hash');
    if (masterPass == null) {
      return false;
    }
    _masterKey = masterPass;
    return true;
  }

  bool checkMasterKey(String key) {
    return hashString(key) == _masterKey;
  }

  Future<void> setMasterKey(String key, String name) async {
    await _initializePrefs();
    await _prefs?.setString('master-hash', hashString(key));
    await _prefs?.setString('vault-name', name);
  }

  String encryptData(String key, String data) {
    final keyF = _generateAESKey(key);
    final iv = encrypt.IV.fromSecureRandom(16); // Generate a new random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(keyF));

    final encrypted = encrypter.encrypt(data, iv: iv);

    // Store both IV and encrypted data as JSON
    return jsonEncode({'iv': iv.base64, 'data': encrypted.base64});
  }

  String decryptData(String key, String encryptedJson) {
    final keyF = _generateAESKey(key);

    // Parse the JSON to extract IV and encrypted data
    final Map<String, dynamic> payload = jsonDecode(encryptedJson);
    final iv = encrypt.IV.fromBase64(payload['iv']);
    final encryptedData = payload['data'];

    // Initialize AES encrypter
    final encrypter = encrypt.Encrypter(encrypt.AES(keyF));

    // Decrypt the data
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedData),
        iv: iv);
  }

  static String hashString(String data) {
    final hash = sha256.convert(utf8.encode(data));
    return hash.toString();
  }

  Future<void> setData(String key, String data) async {
    await _initializePrefs();
    final encryptedData = encryptData(key, data);
    await _prefs?.setString("data", encryptedData);
  }

  Future<String> getData(String key) async {
    await _initializePrefs();
    final encryptedData = _prefs?.getString("data");
    if (encryptedData == null) {
      return "";
    }
    return decryptData(key, encryptedData);
  }

  Future<String> getVaultName() async {
    await _initializePrefs();
    final name= _prefs?.getString("vault-name");
    if (name == null) {
      return "";
    }
    return name;
  }

  Future<void> addData(String key, Map<String, dynamic> newData) async {
    await _initializePrefs();

    // Decrypt existing data or initialize an empty list
    final encryptedData = _prefs?.getString("data");
    List<Map<String, dynamic>> dataList = [];

    if (encryptedData != null) {
      try {
        final decryptedData = decryptData(key, encryptedData);
        final List<dynamic> tempList = jsonDecode(decryptedData);

        // Convert to List<Map<String, dynamic>>
        dataList = tempList.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (e) {
        print("Failed to parse existing data: $e");
      }
    }

    // Add a unique ID to the new data
    newData['id'] = const Uuid().v4(); // Generate a unique ID

    // Add the new data
    dataList.add(newData);

    // Encrypt and save the updated list
    final encryptedList = encryptData(key, jsonEncode(dataList));
    await _prefs?.setString("data", encryptedList);
  }

  Future<void> deleteDataById(String key, String id) async {
    await _initializePrefs();

    // Decrypt existing data
    final encryptedData = _prefs?.getString("data");
    if (encryptedData == null) {
      print("No data found.");
      return;
    }

    try {
      final decryptedData = decryptData(key, encryptedData);
      final List<dynamic> tempList = jsonDecode(decryptedData);

      // Convert to List<Map<String, dynamic>> and remove the item with the matching ID
      List<Map<String, dynamic>> dataList =
      tempList.map((e) => Map<String, dynamic>.from(e)).toList();
      final initialLength = dataList.length;
      dataList.removeWhere((item) => item['id'] == id);

      if (dataList.length == initialLength) {
        print("No item found with ID: $id");
        return;
      }

      // Encrypt and save the updated list
      final encryptedList = encryptData(key, jsonEncode(dataList));
      await _prefs?.setString("data", encryptedList);
      print("Item with ID: $id deleted successfully.");
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  // Utility method to generate AES Key
  encrypt.Key _generateAESKey(String key) {
    if (key.isEmpty) {
      throw ArgumentError("Key cannot be empty");
    }
    return encrypt.Key.fromUtf8(key.padRight(32, '0').substring(0, 32));
  }
}
