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

  Future<void> getCartDevices() async {
    try {
      cart = FirebaseResponse.loading('loading');
      notifyListeners();
      final snapshot = await getIt<FirebaseService>().firestore
          .collection('cart')
          .where('userID', isEqualTo: SharedPrefController().getUser().userId)
          .get();
      cart = FirebaseResponse.completed(
        snapshot.docs.map((element) {
          return CartModel.fromSnapshot(element);
        }).toList(),
      );
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
      await getCartDevices();
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

      await getIt<FirebaseService>().firestore.collection('order').add({
        "status": "pending",
        "info": {"phone": mobile, "address": address},
        "devices": devicesList, // ✅ all items in one order
        "createdAt": FieldValue.serverTimestamp(),
        "userID": SharedPrefController().getUser().userId,
      });

      await clearCart();
      await getCartDevices();

      showSnackBarCustom(
        text: 'تم الاضافة بنجاح لقائمة الطلبات',
        backgroundColor: Colors.green,
      );

      NavigationManager.mayPop();
    } catch (e) {
      debugPrint(e.toString());
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
    notifyListeners();
  }

  Future<void> getActiveOrder() async {
    activeOrder = FirebaseResponse.loading('loading');
    notifyListeners();

    try {
      final snapshot = await getIt<FirebaseService>().firestore
          .collection('order')
          .where('userID', isEqualTo: SharedPrefController().getUser().userId)
          .where('status', isEqualTo: "pending")
          .get();

      final orders = snapshot.docs
          .map((e) => OrderModel.fromSnapshot(e))
          .toList();

      activeOrder = FirebaseResponse.completed(orders);
    } catch (e) {
      activeOrder = FirebaseResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> getCompletedOrder() async {
    completedOrder = FirebaseResponse.loading('loading');
    notifyListeners();

    try {
      final snapshot = await getIt<FirebaseService>().firestore
          .collection('order')
          .where('userID', isEqualTo: SharedPrefController().getUser().userId)
          .where('status', isEqualTo: "completed")
          .get();

      final orders = snapshot.docs
          .map((e) => OrderModel.fromSnapshot(e))
          .toList();

      completedOrder = FirebaseResponse.completed(orders);
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

      // refresh lists
      await getActiveOrder();

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
