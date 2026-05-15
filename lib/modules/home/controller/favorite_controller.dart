import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/device_model.dart';

class FavoriteController extends ChangeNotifier {
  List<DeviceModel> _favorites = [];

  List<DeviceModel> get favorites => _favorites;

  static const String _key = 'favorites_devices';

  /// INIT (load from local storage)
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data != null) {
      final List decoded = jsonDecode(data);
      _favorites = decoded.map((e) => DeviceModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  /// ADD / REMOVE
  void toggleFavorite(DeviceModel device) {
    final exists = _favorites.any((e) => e.deviceId == device.deviceId);

    if (exists) {
      _favorites.removeWhere((e) => e.deviceId == device.deviceId);
    } else {
      _favorites.add(device);
    }

    _saveToPrefs();
    notifyListeners();
  }

  /// CHECK
  bool isFavorite(String deviceId) {
    return _favorites.any((e) => e.deviceId == deviceId);
  }

  /// SAVE
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  /// CLEAR
  void clearFavorites() {
    _favorites.clear();
    _saveToPrefs();
    notifyListeners();
  }
}
