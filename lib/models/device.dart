// To parse this JSON data, do
//
//     final device = deviceFromJson(jsonString);

import 'dart:convert';

import 'package:fulbito/models/user.dart';

Device deviceFromJson(String str) => Device.fromJson(json.decode(str));

String deviceToJson(Device data) => json.encode(data.toJson());

class Device {
  Device({
    this.deviceMessages,
    this.deviceId,
    this.jwToken,
    this.id,
    this.user,
    this.type,
    this.language,
  });

  List<dynamic> deviceMessages;
  String deviceId;
  String jwToken;
  String id;
  User user;
  String type;
  String language;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    deviceMessages: List<dynamic>.from(json["deviceMessages"].map((x) => x)),
    deviceId: json["deviceId"],
    jwToken: json["JWToken"],
    id: json["_id"],
    user: User.fromJson(json["user"]),
    type: json["type"],
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "deviceMessages": List<dynamic>.from(deviceMessages.map((x) => x)),
    "deviceId": deviceId,
    "JWToken": jwToken,
    "_id": id,
    "user": user?.toJson(),
    "type": type,
    "language": language,
  };
}