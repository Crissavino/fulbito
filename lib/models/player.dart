import 'dart:convert';

import 'package:fulbito/models/message.dart';
import 'package:fulbito/models/user.dart';

Player playerFromJson(String str) => Player.fromJson(json.decode(str));

String playerToJson(Player data) => json.encode(data.toJson());

class Player {
  Player({
    this.teams,
    this.messages,
    this.id,
    this.user,
  });

  List<dynamic> teams;
  List<dynamic> messages;
  String id;
  dynamic user;

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      teams: json["teams"] != [] ? List<dynamic>.from(json["teams"].map((x) => x)) : [],
      messages: json["messages"] != [] ? List<dynamic>.from(json["messages"].map((x) => x)) : [],
      id: json["_id"] ?? '',
      user: json["user"] ?? null,
    );
  }

  Map<String, dynamic> toJson() => {
        "teams": teams.isNotEmpty ? List<dynamic>.from(teams.map((x) => x)) : [],
        "messages": messages.isNotEmpty ? List<dynamic>.from(messages.map((x) => x)) : [],
        "_id": id,
        "user": user,
      };
}
