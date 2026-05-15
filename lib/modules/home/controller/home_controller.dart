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

  Future<FirebaseResponse> getLastAddedDevices() async {
    lastAddedDevices = FirebaseResponse.loading('loading');
    notifyListeners();

    final list = await _loadDevices();
    list.shuffle(Random());
    lastAddedDevices = FirebaseResponse.completed(list.take(5).toList());
    notifyListeners();
    return lastAddedDevices;
  }

  Future<FirebaseResponse> getMostOrderedDevices() async {
    mostOrderedDevices = FirebaseResponse.loading('loading');
    notifyListeners();

    final list = await _loadDevices();
    list.shuffle(Random());
    mostOrderedDevices = FirebaseResponse.completed(list.take(5).toList());
    notifyListeners();
    return mostOrderedDevices;
  }

  Future<void> getDevices() async {
    devices = FirebaseResponse.loading('loading');
    notifyListeners();
    devices = FirebaseResponse.completed(await _loadDevices());
    notifyListeners();
  }

  Future<List<DeviceModel>> _loadDevices() async {
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
