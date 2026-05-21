import 'dart:math';

import 'package:flutter/widgets.dart';
import '../../../core/services/mock_api/medical_store_api.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/services/remote_services/firebase_init.dart';
import '../model/device_model.dart';

class HomeController extends ChangeNotifier {
  FirebaseResponse<List<DeviceModel>> lastAddedDevices =
      FirebaseResponse.init();
  FirebaseResponse<List<DeviceModel>> mostOrderedDevices =
      FirebaseResponse.init();
  FirebaseResponse<List<DeviceModel>> devices = FirebaseResponse.init();

  final MedicalStoreApi _api = const MedicalStoreApi();
  final Duration _cacheDuration = const Duration(minutes: 5);

  List<DeviceModel>? _devicesCache;
  DateTime? _devicesLoadedAt;
  Future<List<DeviceModel>>? _devicesRequest;

  bool get _hasFreshDevicesCache {
    final loadedAt = _devicesLoadedAt;
    return _devicesCache != null &&
        loadedAt != null &&
        DateTime.now().difference(loadedAt) < _cacheDuration;
  }

  Future<FirebaseResponse> getLastAddedDevices({bool force = false}) async {
    if (!force && lastAddedDevices.status == Status.COMPLETED) {
      return lastAddedDevices;
    }

    if (lastAddedDevices.data == null) {
      lastAddedDevices = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    final list = List<DeviceModel>.of(await _loadDevices(force: force));
    list.shuffle(Random());
    lastAddedDevices = FirebaseResponse.completed(list.take(5).toList());
    notifyListeners();
    return lastAddedDevices;
  }

  Future<FirebaseResponse> getMostOrderedDevices({bool force = false}) async {
    if (!force && mostOrderedDevices.status == Status.COMPLETED) {
      return mostOrderedDevices;
    }

    if (mostOrderedDevices.data == null) {
      mostOrderedDevices = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    final list = List<DeviceModel>.of(await _loadDevices(force: force));
    list.shuffle(Random());
    mostOrderedDevices = FirebaseResponse.completed(list.take(5).toList());
    notifyListeners();
    return mostOrderedDevices;
  }

  Future<void> getDevices({bool force = false}) async {
    if (!force && devices.status == Status.COMPLETED && _hasFreshDevicesCache) {
      return;
    }

    if (devices.data == null) {
      devices = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    devices = FirebaseResponse.completed(await _loadDevices(force: force));
    notifyListeners();
  }

  Future<List<DeviceModel>> _loadDevices({bool force = false}) async {
    if (!force && _hasFreshDevicesCache) return _devicesCache!;
    if (!force && _devicesRequest != null) return _devicesRequest!;

    _devicesRequest = _fetchDevices();
    try {
      final result = await _devicesRequest!;
      _devicesCache = result;
      _devicesLoadedAt = DateTime.now();
      return result;
    } finally {
      _devicesRequest = null;
    }
  }

  Future<List<DeviceModel>> _fetchDevices() async {
    try {
      final value = await getIt<FirebaseService>().firestore
          .collection('devices')
          .get();
      final remote = value.docs.map(DeviceModel.fromSnapshot).toList();
      if (remote.isNotEmpty) return remote;
    } catch (_) {}

    return _api.getDevices();
  }
}
