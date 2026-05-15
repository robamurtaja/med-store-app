import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String name;
  final String image;
  final String categoryId;
  CategoryModel({
    required this.name,
    required this.image,
    required this.categoryId,
  });

  factory CategoryModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return CategoryModel(
        name: snapshot['name'],
        image: snapshot['image'],
        categoryId: snapshot.id);
  }

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'],
      image: map['image'],
      categoryId: map['categoryId'],
    );
  }

  @override
  String toString() =>
      'CategoryModel(name: $name, image: $image, categoryId: $categoryId)';
}
