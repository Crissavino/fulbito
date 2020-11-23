import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fulbito/models/user.dart';

DeviceMessage deviceMessageModelFromJson(String str) =>
    DeviceMessage.fromJson(json.decode(str));

String deviceMessageModelToJson(DeviceMessage data) =>
    json.encode(data.toJson());

class DeviceMessage {
  String id;
  dynamic sender;
  dynamic messagePlayer;
  dynamic device;
  dynamic chatRoom;
  dynamic time;
  String text;
  bool isLiked;
  bool unread;
  String language;

  DeviceMessage({
    this.id,
    this.sender,
    this.messagePlayer,
    this.device,
    this.chatRoom,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.language,
  });

  factory DeviceMessage.fromJson(Map<String, dynamic> json) => DeviceMessage(
        id: json["_id"],
        sender: json["sender"],
        messagePlayer: json["messagePlayer"],
        device: json["device"],
        chatRoom: json["chatRoom"],
        time: json["time"],
        text: json["text"],
        isLiked: json["isLiked"],
        unread: json["unread"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "messagePlayer": messagePlayer,
        "sender": sender,
        "device": device,
        "chatRoom": chatRoom,
        "time": time,
        "text": text,
        "isLiked": isLiked,
        "unread": unread,
        "language": language,
      };
}
