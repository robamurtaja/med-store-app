import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/model/device_model.dart';

class CartModel {
  final String userId;
  final DeviceModel device;
  final String cartId;
  final int count;
  CartModel({
    required this.device,
    required this.userId,
    required this.cartId,
    required this.count,
  });

  factory CartModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return CartModel(
      cartId: snapshot.id,
      count: snapshot['count'],
      device: DeviceModel.fromJson(snapshot['product']),
      userId: snapshot['userID'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userID': userId,
      'product': device.toJson(),
      'count': count,
    };
  }
}
