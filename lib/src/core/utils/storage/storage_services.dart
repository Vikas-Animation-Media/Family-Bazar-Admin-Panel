import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    try {
      await GetStorage.init();
      _box = GetStorage();
      return this;
    } catch (e, stackTrace) {
      debugPrint('--- [CRITICAL] GetStorage Init Failed ---');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      throw Exception('Failed to initialize local storage via GetStorage.');
    }
  }

  /// Global Storage Error Logger
  void _logStorageError(String operation, String key, Object error, StackTrace stackTrace) {
    debugPrint('--- [STORAGE EXCEPTION] Operation: $operation | Key: $key ---');
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  }

  /// Centralized read logic
  T? _readData<T>(String key) {
    try {
      return _box.read<T>(key);
    } catch (e, stackTrace) {
      _logStorageError('read<$T>', key, e, stackTrace);
      return null;
    }
  }

  /// GETTERS
  String? getString(String key) => _readData<String>(key);
  bool? getBool(String key)   => _readData<bool>(key);
  int? getInt(String key)     => _readData<int>(key);
  double? getDouble(String key) => _readData<double>(key);


  /// Centralized write logic
  Future<bool> _writeData(String key, dynamic value) async {
    try {
      await _box.write(key, value);
      return true;
    } catch (e, stackTrace) {
      _logStorageError('write', key, e, stackTrace);
      return false;
    }
  }

  /// SETTERS (Asynchronous)
  Future<bool> setString(String key, String value) async => _writeData(key, value);
  Future<bool> setBool(String key, bool value)   async => _writeData(key, value);
  Future<bool> setInt(String key, int value)     async => _writeData(key, value);
  Future<bool> setDouble(String key, double value) async => _writeData(key, value);
  
  /// Clear All Data (Session wipe)
  Future<bool> clearAll() async {
    try {
      await _box.erase();
      return true;
    } catch (e, stackTrace) {
      debugPrint('--- [STORAGE EXCEPTION] Operation: clearAll ---');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      return false;
    }
  }
}
