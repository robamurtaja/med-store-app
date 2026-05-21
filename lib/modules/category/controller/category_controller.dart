import 'dart:math';

import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/services/local_services/shared_perf.dart';
import '../../../core/services/mock_api/medical_store_api.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/services/remote_services/firebase_init.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/show_snackbar.dart';
import '../../home/model/device_model.dart';
import '../model/category_model.dart';

class CategoryController extends ChangeNotifier {
  FirebaseResponse<List<CategoryModel>> categories = FirebaseResponse.init();
  FirebaseResponse<List<DeviceModel>> devices = FirebaseResponse.init();
  FirebaseResponse<List<DeviceModel>> lastAddedDevices =
      FirebaseResponse.init();

  final MedicalStoreApi _api = const MedicalStoreApi();
  final Duration _cacheDuration = const Duration(minutes: 5);

  List<CategoryModel>? _categoriesCache;
  DateTime? _categoriesLoadedAt;
  Future<List<CategoryModel>>? _categoriesRequest;

  final Map<String, List<DeviceModel>> _devicesByCategory = {};
  final Map<String, DateTime> _devicesLoadedAt = {};
  final Map<String, Future<List<DeviceModel>>> _devicesRequests = {};
  String? _currentCategoryId;

  bool get _hasFreshCategoriesCache {
    final loadedAt = _categoriesLoadedAt;
    return _categoriesCache != null &&
        loadedAt != null &&
        DateTime.now().difference(loadedAt) < _cacheDuration;
  }

  bool _hasFreshDevicesCache(String key) {
    final loadedAt = _devicesLoadedAt[key];
    return _devicesByCategory.containsKey(key) &&
        loadedAt != null &&
        DateTime.now().difference(loadedAt) < _cacheDuration;
  }

  Future<FirebaseResponse> getCategory({bool force = false}) async {
    if (!force &&
        categories.status == Status.COMPLETED &&
        _hasFreshCategoriesCache) {
      return categories;
    }

    if (categories.data == null) {
      categories = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    categories = FirebaseResponse.completed(
      await _loadCategories(force: force),
    );
    notifyListeners();
    return categories;
  }

  Future<void> getDevices(String categoryId, {bool force = false}) async {
    final isSameCategory = _currentCategoryId == categoryId;
    final hasFreshCache = _hasFreshDevicesCache(categoryId);

    if (!force &&
        isSameCategory &&
        devices.status == Status.COMPLETED &&
        hasFreshCache) {
      return;
    }

    _currentCategoryId = categoryId;

    if (!force && hasFreshCache) {
      devices = FirebaseResponse.completed(_devicesByCategory[categoryId]);
      notifyListeners();
      return;
    }

    if (!isSameCategory ||
        devices.data == null ||
        devices.status == Status.INIT) {
      devices = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    devices = FirebaseResponse.completed(
      await _loadDevices(categoryId, force: force),
    );
    notifyListeners();
  }

  Future<FirebaseResponse> getLastAddedDevices({bool force = false}) async {
    if (!force && lastAddedDevices.status == Status.COMPLETED) {
      return lastAddedDevices;
    }

    if (lastAddedDevices.data == null) {
      lastAddedDevices = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    final list = List<DeviceModel>.of(await _loadDevices(null, force: force));
    list.shuffle(Random());
    lastAddedDevices = FirebaseResponse.completed(list.take(5).toList());
    notifyListeners();
    return lastAddedDevices;
  }

  Future<List<CategoryModel>> _loadCategories({bool force = false}) async {
    if (!force && _hasFreshCategoriesCache) return _categoriesCache!;
    if (!force && _categoriesRequest != null) return _categoriesRequest!;

    _categoriesRequest = _fetchCategories();
    try {
      final result = await _categoriesRequest!;
      _categoriesCache = result;
      _categoriesLoadedAt = DateTime.now();
      return result;
    } finally {
      _categoriesRequest = null;
    }
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    try {
      final value = await getIt<FirebaseService>().firestore
          .collection('Category')
          .get();
      final remote = value.docs.map(CategoryModel.fromSnapshot).toList();
      if (remote.isNotEmpty) return remote;
    } catch (_) {}

    return _api.getCategories();
  }

  Future<List<DeviceModel>> _loadDevices(
    String? categoryId, {
    bool force = false,
  }) async {
    final key = categoryId ?? '__all__';
    if (!force && _hasFreshDevicesCache(key)) return _devicesByCategory[key]!;
    if (!force && _devicesRequests[key] != null) return _devicesRequests[key]!;

    _devicesRequests[key] = _fetchDevices(categoryId);
    try {
      final result = await _devicesRequests[key]!;
      _devicesByCategory[key] = result;
      _devicesLoadedAt[key] = DateTime.now();
      return result;
    } finally {
      _devicesRequests.remove(key);
    }
  }

  Future<List<DeviceModel>> _fetchDevices(String? categoryId) async {
    try {
      var query = getIt<FirebaseService>().firestore.collection('devices');
      final value = categoryId == null
          ? await query.get()
          : await query.where('categoryId', isEqualTo: categoryId).get();
      final remote = value.docs.map(DeviceModel.fromSnapshot).toList();
      if (remote.isNotEmpty) return remote;
    } catch (_) {}

    return _api.getDevices(categoryId: categoryId);
  }

  Future<bool> addToCart(DeviceModel deviceModel, int count) async {
    final userId =
        getIt<FirebaseService>().auth.currentUser?.uid ??
        SharedPrefController().getUser().userId;
    if (userId == null || userId.isEmpty) {
      showSnackBarCustom(text: 'Something went wrong');
      return false;
    }

    loadingWithText(text: 'اضافة للسلة...');
    try {
      await getIt<FirebaseService>().firestore.collection('cart').add({
        "userID": userId,
        "count": count,
        "product": deviceModel.toJson(),
      });
      NavigationManager.mayPop();
      showSnackBarCustom(
        text: 'تمت الإضافة بنجاح',
        backgroundColor: Colors.green,
      );
      return true;
    } catch (e) {
      NavigationManager.mayPop();
      showSnackBarCustom(text: 'حدث خطأ ما');
      return false;
    }
  }
}
