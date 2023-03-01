library simp_cache;

import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:simp_cache/src/simp_cache_constants.dart';

class SimpCache {
  SimpCache._internal();
  static final SimpCache instance = SimpCache._internal();

  Map<String, dynamic> _cachedItems = {};

  ///This method caches item in SharedPreferences and returns a boolean to indicate success or failure.
  Future<bool> cacheItem(String key, Object value) async {
    final EncryptedSharedPreferences _encryptedSharedPreferences =
        EncryptedSharedPreferences();
    final _secured = await _encryptedSharedPreferences.getInstance();
    _cachedItems[key] = jsonEncode(value);
    return _secured.setString(
        SimpCacheConstants.items, jsonEncode(_cachedItems));
  }

  ///This method is Future and returns a cached item if it exists.
  Future<String> getItemByKey(String key, {bool showSource = false}) async {
    await _getCachedItems(showSource: showSource);
    return _cachedItems.containsKey(key) ? _cachedItems[key] : '';
  }

  ///This method removes items from Ram & SharedPreferences and returns a boolean to indicate success or failure.
  Future<bool> removeItemByKey(String key) async {
    final EncryptedSharedPreferences _encryptedSharedPreferences =
        EncryptedSharedPreferences();
    final _secured = await _encryptedSharedPreferences.getInstance();
    await _getCachedItems();
    _cachedItems.remove(key);
    return _secured.setString(
        SimpCacheConstants.items, jsonEncode(_cachedItems));
  }

  ///This method prints all cached items (in debug mode only).
  Future<void> showCachedItems({bool showSource = false}) async {
    await _getCachedItems(showSource: showSource);
    _cachedItems.forEach((key, value) {
      if (kDebugMode) {
        debugPrint('$key - $value');
      }
    });
  }

  ///This method is not Future and returns a cached item by checking RAM only, if the item doesn't exist then it returns null.
  String? getItemByKeySync(String key) {
    return _cachedItems.containsKey(key) ? _cachedItems[key] : null;
  }

  ///This method clears all cached items and empties RAM then returns a boolean to indicate success or failure.
  Future<bool> clearCache() async {
    _cachedItems = {};

    final EncryptedSharedPreferences _encryptedSharedPreferences =
        EncryptedSharedPreferences();
    final _secured = await _encryptedSharedPreferences.getInstance();
    return _secured.remove(SimpCacheConstants.items);
  }

  /// ---------------- \\\

  Future<Map<String, dynamic>?> _getCachedItems(
      {bool showSource = false}) async {
    final EncryptedSharedPreferences _encryptedSharedPreferences =
        EncryptedSharedPreferences();
    final _secured = await _encryptedSharedPreferences.getInstance();

    try {
      if (_cachedItems.isNotEmpty) {
        if (showSource && kDebugMode) {
          debugPrint('SimpCache from RAM');
        }
        return _cachedItems;
      } else if (_secured.containsKey(SimpCacheConstants.items)) {
        if (showSource && kDebugMode) {
          debugPrint('SimpCache from SharedPreferences');
        }
        _cachedItems = await _getItemsFromDeviceStorage();
        _secured.setString(SimpCacheConstants.items, jsonEncode(_cachedItems));

        return _cachedItems;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('SimpCache error @ : $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> _getItemsFromDeviceStorage() async {
    final EncryptedSharedPreferences _encryptedSharedPreferences =
        EncryptedSharedPreferences();
    final _secured = await _encryptedSharedPreferences.getInstance();
    final value = _secured.getString(SimpCacheConstants.items) ?? '';

    return jsonDecode(value);
  }
}
