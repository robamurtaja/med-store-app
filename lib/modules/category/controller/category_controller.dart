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

  Future<FirebaseResponse> getCategory() async {
    categories = FirebaseResponse.loading('loading');
    notifyListeners();

    categories = FirebaseResponse.completed(await _loadCategories());
    notifyListeners();
    return categories;
  }

  Future<void> getDevices(String categoryId) async {
    devices = FirebaseResponse.loading('loading');
    notifyListeners();

    devices = FirebaseResponse.completed(await _loadDevices(categoryId));
    notifyListeners();
  }

  Future<FirebaseResponse> getLastAddedDevices() async {
    lastAddedDevices = FirebaseResponse.loading('loading');
    notifyListeners();

    final list = await _loadDevices(null);
    list.shuffle(Random());
    lastAddedDevices = FirebaseResponse.completed(list.take(5).toList());
    notifyListeners();
    return lastAddedDevices;
  }

  Future<List<CategoryModel>> _loadCategories() async {
    try {
      final value = await getIt<FirebaseService>().firestore
          .collection('Category')
          .get();
      final remote = value.docs.map(CategoryModel.fromSnapshot).toList();
      if (remote.isNotEmpty) return remote;
    } catch (_) {}

    return _api.getCategories();
  }

  Future<List<DeviceModel>> _loadDevices(String? categoryId) async {
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
