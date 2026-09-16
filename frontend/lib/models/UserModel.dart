// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

List<UsersModel> usersModelFromJson(String str) =>
    List<UsersModel>.from(json.decode(str).map((x) => UsersModel.fromJson(x)));

String usersModelToJson(List<UsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersModel {
  final String name;
  final String email;
  final String role;
  final int id;

  UsersModel({
    required this.name,
    required this.email,
    required this.role,
    required this.id,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
    name: json["name"],
    email: json["email"],
    role: json["role"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "role": role,
    "id": id,
  };
}
