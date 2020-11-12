import 'dart:convert';

import 'package:fulbito/models/player.dart';

ChatRoom chatRoomModelFromJson(String str) =>
    ChatRoom.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoom data) => json.encode(data.toJson());

class ChatRoom {
  String id;
  String name;
  String description;
  bool isPinned;
  bool unreadMessages;
  dynamic team;
  List<dynamic> messages;
  List<Player> players;
  dynamic lastMessage;
  String image;
  dynamic owner;

  ChatRoom({
    this.id,
    this.name,
    this.description,
    this.isPinned,
    this.unreadMessages,
    this.team,
    this.messages,
    this.players,
    this.lastMessage,
    this.image,
    this.owner,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        isPinned: json["isPinned"],
        unreadMessages: json["unreadMessages"],
        team: json["team"],
        messages: json["messages"],
        players: json["players"],
        lastMessage: json["lastMessage"],
        image: json["image"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "isPinned": isPinned,
        "unreadMessages": unreadMessages,
        "team": team,
        "messages": messages,
        "players": players,
        "lastMessage": lastMessage,
        "image": image,
        "owner": owner,
      };
}

// EXAMPLE CHATS ON HOME SCREEN
// List<MessageModel> chats = [
//   MessageModel(
//     sender: james,
//     time: '5:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: true,
//   ),
//   MessageModel(
//     sender: olivia,
//     time: '4:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: true,
//   ),
//   MessageModel(
//     sender: john,
//     time: '3:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
//   MessageModel(
//     sender: sophia,
//     time: '2:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: true,
//   ),
//   MessageModel(
//     sender: steven,
//     time: '1:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
//   MessageModel(
//     sender: sam,
//     time: '12:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
//   MessageModel(
//     sender: greg,
//     time: '11:30 AM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
// ];
