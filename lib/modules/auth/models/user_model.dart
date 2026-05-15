// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? userId;
  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password,
      this.userId});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        password: map['password'] ?? '',
        userId: map['userId']);
  }

  factory UserModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        phone: snapshot['phone'],
        password: '',
        userId: snapshot.id);
  }

  Map<String, dynamic> toJsonUser() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'userId': userId
    };
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, userId: $userId)';
  }
}
