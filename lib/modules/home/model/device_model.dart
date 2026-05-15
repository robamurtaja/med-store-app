import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String name;
  final String image;
  final String categoryId;
  final String price;
  final String details;
  final String deviceId;
  final String forUsage;
  final String note;
  final List<String> points;

  DeviceModel({
    required this.name,
    required this.image,
    required this.categoryId,
    required this.details,
    required this.price,
    required this.deviceId,
    required this.forUsage,
    required this.note,
    required this.points,
  });

  factory DeviceModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return DeviceModel(
      categoryId: _readString(data, 'categoryId'),
      name: _readString(data, 'name'),
      image: _readString(data, 'image'),
      details: _readString(data, 'details'),
      deviceId: snapshot.id,
      price: _readString(data, 'price'),
      note: _readString(data, 'note'),
      forUsage: _readString(data, 'for'),
      points: _readStringList(data, 'points'),
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> map) {
    return DeviceModel(
      categoryId: _readString(map, 'categoryId'),
      name: _readString(map, 'name'),
      image: _readString(map, 'image'),
      details: _readString(map, 'details'),
      deviceId: _readString(map, 'deviceId'),
      price: _readString(map, 'price'),
      note: _readString(map, 'note'),
      forUsage: _readString(map, 'for'),
      points: _readStringList(map, 'points'),
    );
  }
  int get priceValue =>
      int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'categoryId': categoryId,
      'price': price,
      'details': details,
      'deviceId': deviceId,
      'for': forUsage,
      'note': note,
      'points': points,
    };
  }

  @override
  String toString() {
    return 'DeviceModel(name: $name, image: $image, categoryId: $categoryId, price: $price, details: $details, deviceId: $deviceId)';
  }
}

String _readString(
  Map<String, dynamic> map,
  String key, {
  String fallback = '',
}) {
  final value = map[key];
  if (value == null) return fallback;
  return value.toString();
}

List<String> _readStringList(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is List) return value.map((e) => e.toString()).toList();
  return const [];
}
