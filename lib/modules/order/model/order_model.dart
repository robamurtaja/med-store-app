
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medical_devices_app/modules/home/model/device_model.dart';

class OrderModel {
  final String orderId;
  final String phone;
  final String address;
  final String userId;
  final String status;
  final DateTime? createdAt;

  final List<OrderItem> devices; // ✅ changed

  OrderModel({
    required this.orderId,
    required this.phone,
    required this.address,
    required this.userId,
    required this.status,
    required this.devices,
    this.createdAt,
  });

  factory OrderModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      orderId: snapshot.id,
      address: data['info']?['address'] ?? '',
      phone: data['info']?['phone'] ?? '',
      userId: data['userID'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      // ✅ map devices list correctly
      devices: (data['devices'] as List<dynamic>? ?? []).map((e) {
        // final product = e['product']; // because structure has "product"
        return OrderItem.fromJson(e);
      }).toList(),
    );
  }

  @override
  String toString() {
    return '''
OrderModel(
  orderId: $orderId,
  phone: $phone,
  address: $address,
  userId: $userId,
  status: $status,
  devices: $devices,
  createdAt: $createdAt
)
''';
  }
}

class OrderItem {
  final DeviceModel deviceModel;
  final int count;

  OrderItem({required this.deviceModel, required this.count});

  factory OrderItem.fromJson(Map<String, dynamic> map) {
    return OrderItem(
      deviceModel: DeviceModel.fromJson(map['product'] as Map<String, dynamic>),
      count: map['count'] as int,
    );
  }
}
