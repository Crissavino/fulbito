// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.online,
    this.chatRooms,
    this.devices,
    this.id,
    this.fullName,
    this.email,
    this.player,
  });

  bool online;
  List<dynamic> chatRooms;
  List<dynamic> devices;
  String id;
  String fullName;
  String email;
  dynamic player;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"] ?? '',
    online: json["online"] ?? false,
    chatRooms: json["chatRooms"] != [] ? List<dynamic>.from(json["chatRooms"].map((x) => x)) : [],
    devices: json["devices"] != [] ? List<dynamic>.from(json["devices"].map((x) => x)) : [],
    fullName: json["fullName"] ?? '',
    email: json["email"] ?? '',
    player: json["player"] ?? null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "online": online,
    "chatRooms": chatRooms.isNotEmpty ? List<dynamic>.from(chatRooms.map((x) => x)) : [],
    "devices": devices.isNotEmpty ? List<dynamic>.from(devices.map((x) => x)) : [],
    "fullName": fullName,
    "email": email,
    "player": player,
  };
}