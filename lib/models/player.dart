import 'dart:convert';

import 'package:fulbito/models/user.dart';

Player playerModelFromJson(String str) => Player.fromJson(json.decode(str));

String playerModelToJson(Player data) => json.encode(data.toJson());

class Player {
  User user;
  List<dynamic> teams;
  List<dynamic> devices;
  List<dynamic> messages;

  Player({
    this.user,
    this.teams,
    this.devices,
    this.messages,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      user: json["user"],
      teams: json["teams"],
      devices: json["devices"],
      messages: json["messages"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user,
        "teams": teams,
        "devices": devices,
        "messages": messages,
      };
}
