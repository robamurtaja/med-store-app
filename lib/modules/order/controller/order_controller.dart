import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/services/remote_services/firebase_init.dart';
import '../../../core/widgets/show_snackbar.dart';
import '../model/cart_model.dart';
import '../model/order_model.dart';

import '../../../core/services/local_services/shared_perf.dart';

class OrderController extends ChangeNotifier {
  FirebaseResponse<List<CartModel>> cart = FirebaseResponse.init();
  FirebaseResponse<List<OrderModel>> activeOrder = FirebaseResponse.init();
  FirebaseResponse<List<OrderModel>> completedOrder = FirebaseResponse.init();

  final Duration _cacheDuration = const Duration(seconds: 45);
  DateTime? _cartLoadedAt;
  DateTime? _activeOrderLoadedAt;
  DateTime? _completedOrderLoadedAt;
  Future<void>? _cartRequest;
  Future<void>? _activeOrderRequest;
  Future<void>? _completedOrderRequest;

  bool _isFresh(DateTime? loadedAt) {
    return loadedAt != null &&
        DateTime.now().difference(loadedAt) < _cacheDuration;
  }

  Future<void> getCartDevices({bool force = false}) async {
    if (!force && cart.status == Status.COMPLETED && _isFresh(_cartLoadedAt)) {
      return;
    }
    if (!force && _cartRequest != null) return _cartRequest!;

    _cartRequest = _fetchCartDevices(showLoading: cart.data == null);
    try {
      await _cartRequest!;
    } finally {
      _cartRequest = null;
    }
  }

  Future<void> _fetchCartDevices({required bool showLoading}) async {
    try {
      if (showLoading) {
        cart = FirebaseResponse.loading('loading');
        notifyListeners();
      }

      final snapshot = await getIt<FirebaseService>().firestore
          .collection('cart')
          .where('userID', isEqualTo: SharedPrefController().getUser().userId)
          .get();
      cart = FirebaseResponse.completed(
        snapshot.docs.map(CartModel.fromSnapshot).toList(),
      );
      _cartLoadedAt = DateTime.now();
      notifyListeners();
    } on Exception {
      cart = FirebaseResponse.error('something went wrong');
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await getIt<FirebaseService>().firestore
          .collection('cart')
          .doc(id)
          .delete();
      cart = FirebaseResponse.completed(
        (cart.data ?? []).where((item) => item.cartId != id).toList(),
      );
      _cartLoadedAt = DateTime.now();
      notifyListeners();
      showSnackBarCustom(text: 'تم الحذف بنجاح');
    } catch (e) {
      showSnackBarCustom(text: 'لم يتم الحذف');
    }
  }

  Future<void> completeOrder({
    required String address,
    required String mobile,
  }) async {
    try {
      final currentCart = cart.data ?? [];
      if (currentCart.isEmpty) {
        showSnackBarCustom(text: 'السلة فارغة');
        return;
      }

      final devicesList = currentCart.map((e) => e.toJson()).toList();

      final String userId = SharedPrefController().getUser().userId ?? '';
      final orderRef = await getIt<FirebaseService>().firestore
          .collection('order')
          .add({
            "status": "pending",
            "info": {"phone": mobile, "address": address},
            "devices": devicesList,
            "createdAt": FieldValue.serverTimestamp(),
            "userID": userId,
          });

      final newOrder = OrderModel(
        orderId: orderRef.id,
        phone: mobile,
        address: address,
        userId: userId,
        status: 'pending',
        createdAt: DateTime.now(),
        devices: currentCart
            .map(
              (item) => OrderItem(deviceModel: item.device, count: item.count),
            )
            .toList(),
      );

      await clearCart();
      activeOrder = FirebaseResponse.completed([
        newOrder,
        ...activeOrder.data ?? const <OrderModel>[],
      ]);
      _activeOrderLoadedAt = DateTime.now();
      notifyListeners();

      showSnackBarCustom(
        text: 'تمت الإضافة بنجاح لقائمة الطلبات',
        backgroundColor: Colors.green,
      );

      NavigationManager.mayPop();
    } catch (e) {
      debugPrint(e.toString());
      showSnackBarCustom(text: 'فشل تأكيد الطلب');
    }
  }

  Future<void> clearCart() async {
    final currentCart = cart.data ?? [];
    await Future.wait(
      currentCart.map(
        (e) => getIt<FirebaseService>().firestore
            .collection('cart')
            .doc(e.cartId)
            .delete(),
      ),
    );
    cart = FirebaseResponse.completed([]);
    _cartLoadedAt = DateTime.now();
    notifyListeners();
  }

  Future<void> getActiveOrder({bool force = false}) async {
    if (!force &&
        activeOrder.status == Status.COMPLETED &&
        _isFresh(_activeOrderLoadedAt)) {
      return;
    }
    if (!force && _activeOrderRequest != null) return _activeOrderRequest!;

    _activeOrderRequest = _fetchActiveOrder(
      showLoading: activeOrder.data == null,
    );
    try {
      await _activeOrderRequest!;
    } finally {
      _activeOrderRequest = null;
    }
  }

  Future<void> _fetchActiveOrder({required bool showLoading}) async {
    if (showLoading) {
      activeOrder = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    try {
      final snapshot = await getIt<FirebaseService>().firestore
          .collection('order')
          .where('userID', isEqualTo: SharedPrefController().getUser().userId)
          .where('status', isEqualTo: "pending")
          .get();

      final orders = snapshot.docs.map(OrderModel.fromSnapshot).toList();
      activeOrder = FirebaseResponse.completed(orders);
      _activeOrderLoadedAt = DateTime.now();
    } catch (e) {
      activeOrder = FirebaseResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> getCompletedOrder({bool force = false}) async {
    if (!force &&
        completedOrder.status == Status.COMPLETED &&
        _isFresh(_completedOrderLoadedAt)) {
      return;
    }
    if (!force && _completedOrderRequest != null) {
      return _completedOrderRequest!;
    }

    _completedOrderRequest = _fetchCompletedOrder(
      showLoading: completedOrder.data == null,
    );
    try {
      await _completedOrderRequest!;
    } finally {
      _completedOrderRequest = null;
    }
  }

  Future<void> _fetchCompletedOrder({required bool showLoading}) async {
    if (showLoading) {
      completedOrder = FirebaseResponse.loading('loading');
      notifyListeners();
    }

    try {
      final snapshot = await getIt<FirebaseService>().firestore
          .collection('order')
          .where('userID', isEqualTo: SharedPrefController().getUser().userId)
          .where('status', isEqualTo: "completed")
          .get();

      final orders = snapshot.docs.map(OrderModel.fromSnapshot).toList();
      completedOrder = FirebaseResponse.completed(orders);
      _completedOrderLoadedAt = DateTime.now();
    } catch (e) {
      completedOrder = FirebaseResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await getIt<FirebaseService>().firestore
          .collection('order')
          .doc(orderId)
          .update({"status": "canceled"});

      await getActiveOrder(force: true);

      showSnackBarCustom(
        text: 'تم إلغاء الطلب بنجاح',
        backgroundColor: Colors.red,
      );
      NavigationManager.mayPop();
    } catch (e) {
      debugPrint(e.toString());
      showSnackBarCustom(text: 'فشل إلغاء الطلب');
    }
  }
}
