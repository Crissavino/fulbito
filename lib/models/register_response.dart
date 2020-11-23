// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

import 'package:fulbito/models/user.dart';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    this.success,
    this.message,
    this.user,
    this.token,
  });

  bool success;
  String message;
  User user;
  String token;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    success: json["success"],
    message: json["message"],
    user: User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user": user.toJson(),
    "token": token,
  };
}