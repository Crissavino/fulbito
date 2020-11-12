import 'dart:convert';

import 'package:fulbito/models/user.dart';

Message messageModelFromJson(String str) => Message.fromJson(json.decode(str));

String messageModelToJson(Message data) => json.encode(data.toJson());

class Message {
  User sender;
  String time;
  String text;
  bool isLiked;
  bool unread;
  String language;
  dynamic chatRoom;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.language,
    this.chatRoom,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: json["sender"],
        time: json["time"],
        text: json["text"],
        isLiked: json["isLiked"],
        unread: json["unread"],
        language: json["language"],
        chatRoom: json["chatRoom"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "time": time,
        "text": text,
        "isLiked": isLiked,
        "unread": unread,
        "language": language,
        "chatRoom": chatRoom,
      };
}
