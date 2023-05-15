import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';

import '../index.dart';

class AppEncryptionUtilities {
  static final _key = crypto.Key.fromUtf8(kEncKey);
  static final _iv = crypto.IV.fromUtf8(kEncIv);

  static final _encrypt =
      crypto.Encrypter(crypto.AES(_key, mode: crypto.AESMode.cbc));

  static Future<Map<String, dynamic>?> getPostMapForApi(String? data) async {
    if (data != null) {
      return await compute(_encodeEncrypted, data);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> _encodeEncrypted(String data) async {
    final encrypted = _encrypt.encrypt(data, iv: _iv);
    return {
      "data": encrypted.base64,
      "passphase": kPassPhase,
    };
  }

  static Future<String> getJsonFromApiData(String data) async {
    return await compute(_decodeEncrypted, data);
  }

  static Future<String> _decodeEncrypted(String data) async {
    final curData = jsonDecode(data)['encoded'];
    final encrypted = crypto.Encrypted.fromBase64(curData);
    return _encrypt.decrypt(encrypted, iv: _iv);
  }

  static Future<String?> toJsonSimple(String data) async {
    return await compute(_decodeSimpleData, data);
  }

  static Future<String?> _decodeSimpleData(String data) async {
    try {
      final encrypted = crypto.Encrypted.fromBase64(data);
      return _encrypt.decrypt(encrypted, iv: _iv);
    } catch (e) {
      return null;
    }
  }
}
