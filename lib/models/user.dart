import 'dart:convert';

import 'package:fulbito/models/player.dart';

User userModelFromJson(String str) => User.fromJson(json.decode(str));

String userModelToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String firebaseId;
  String fullName;
  String email;
  String userName;
  String imageUrl;
  List<dynamic> chatRooms;
  List<dynamic> devices;
  Player player;

  User({
    this.id,
    this.firebaseId,
    this.fullName,
    this.email,
    this.userName,
    this.imageUrl,
    this.chatRooms,
    this.devices,
    this.player,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      firebaseId: json["firebaseId"],
      fullName: json["fullName"],
      email: json["email"],
      userName: json["userName"],
      imageUrl: json["imageUrl"],
      chatRooms: json["chatRooms"],
      devices: json["devices"],
      player: json["player"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firebaseId": firebaseId,
        "fullName": fullName,
        "email": email,
        "userName": userName,
        "imageUrl": imageUrl,
        "chatRooms": chatRooms,
        "devices": devices,
        "player": player,
      };
}
