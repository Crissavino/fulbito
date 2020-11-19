import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/device_message.dart';
import 'package:fulbito/models/player.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/services/users_service.dart';
import 'package:http/http.dart' as http;

class ChatRoomService with ChangeNotifier {
  final String _url = '$NGROK_HTTP/api/chatRooms';
  String _apiKey = 'cdf773c21cdd290fabe0618a20e4f181';
  ChatRoom _selectedChatRoom;

  ChatRoom get selectedChatRoom => this._selectedChatRoom;
  set selectedChatRoom(ChatRoom chatRoom) {
    this._selectedChatRoom = chatRoom;
    notifyListeners();
  }

  Future<List<ChatRoom>> getAllMyChatRooms(
    String userId,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> lastMessage = {
      'text': 'Mensaje de prueba',
    };
    List<Player> players = [
      Player(
        user: User(id: '1', fullName: 'Cris1 Saivino'),
      ),
      Player(
        user: User(id: '2', fullName: 'Cris2 Saivino'),
      ),
      Player(
        user: User(id: '3', fullName: 'Cris3 Saivino'),
      ),
      Player(
        user: User(id: '4', fullName: 'Cris4 Saivino'),
      ),
    ];

    return [
      ChatRoom(
        name: 'Probando',
        unreadMessages: true,
        lastMessage: lastMessage,
        description: 'Esta es una descripcion de prueba1',
        players: players,
      ),
      ChatRoom(
        name: 'Probando 2',
        unreadMessages: false,
        lastMessage: lastMessage,
        description: 'Esta es una descripcion de prueba2',
        players: players,
      ),
    ];
    //RECUPERAR EL BACKEND DEL PENDRIVE
    // final url = '$_url/getAllMyChatRooms?firebaseId=$firebaseId';
    // final resp = await http.get(url);
    // final Map<String, dynamic> decodedData = json.decode(resp.body);

    // if (decodedData == null) return [];
    // if (decodedData['error'] != null) return [];

    // final chatRoomsFromNode = decodedData['chatRooms'];
    // List<ChatRoom> chatRooms = List();

    // chatRoomsFromNode.forEach((value) {
    //   final chatRoom = ChatRoom.fromJson(value);
    //   chatRooms.add(chatRoom);
    // });
    // return chatRooms;
  }

  Future<List<DeviceMessage>> getAllMyChatRoomMessages(
    String chatRoomId,
    String userId,
  ) async {
    await Future.delayed(Duration(seconds: 1));

    return <DeviceMessage>[
      DeviceMessage(
          id: '1',
          sender: User(id: '1', fullName: 'Cris1 Saivino'),
          text: 'Pruebaaaa1'),
      DeviceMessage(
          id: '2',
          sender: User(id: '2', fullName: 'Cris2 Saivino'),
          text: 'Pruebaaaa2'),
      DeviceMessage(
          id: '3',
          sender: User(id: '3', fullName: 'Cris3 Saivino'),
          text: 'Pruebaaaa3'),
      DeviceMessage(
          id: '4',
          sender: User(id: '1', fullName: 'Cris1 Saivino'),
          text:
              'Pruebaaaa4Pruebaaaa4Pruebaaaa4Pruebaaaa4Pruebaaaa4Pruebaaaa4Pruebaaaa4'),
      DeviceMessage(
          id: '5',
          sender: User(id: '2', fullName: 'Cris2 Saivino'),
          text: 'Pruebaaaa5'),
      DeviceMessage(
          id: '6',
          sender: User(id: '7', fullName: 'Cris7 Saivino'),
          text: 'Pruebaaaa6'),
      DeviceMessage(
          id: '7',
          sender: User(id: '1', fullName: 'Cris1 Saivino'),
          text: 'Pruebaaaa7'),
    ];
    //RECUPERAR EL BACKEND DEL PENDRIVE
    // final url =
    //     '$_url/getAllMyChatRoomMessage?userId=$userId&chatRoomId=$chatRoomId';
    // final resp = await http.get(url);

    // final Map<String, dynamic> decodedData = json.decode(resp.body);

    // if (decodedData == null) return [];
    // if (decodedData['error'] != null) return [];

    // final chatRoomMessagesFromNode = decodedData['deviceMessages'];
    // List<DeviceMessageModel> messages = List();
    // chatRoomMessagesFromNode.forEach((value) {
    //   final message = DeviceMessageModel.fromJson(value);
    //   messages.add(message);
    // });

    // return messages;
  }

  // Future<List<DeviceMessageModel>> newMessage(
  //     MessageModel message, UserModel user) async {
  //   final url = '$_url/createMessages?firebaseId=${user.firebaseId}';

  //   final resp = await http.post(url,
  //       headers: {"Content-Type": "application/json"},
  //       body: messageModelToJson(message));

  //   final Map<String, dynamic> decodedData = json.decode(resp.body);

  //   if (decodedData == null) return null;
  //   if (decodedData['success'] != true) return null;

  //   final myLasDeviceMessageFromNode = decodedData['myLastDeviceMessage'];

  //   List<DeviceMessageModel> deviceMessages = List();
  //   myLasDeviceMessageFromNode.forEach((value) {
  //     final message = DeviceMessageModel.fromJson(value);
  //     deviceMessages.add(message);
  //   });

  //   print(deviceMessages);

  //   return deviceMessages;
  // }

  Future<bool> createChatRoom(User currentUser, String groupName,
      List<User> usersToAddToGroup) async {

    // TODO crear el chat room y guardarlo en DB
    final newChatRoom = ChatRoom(
      id: '3',
      name: groupName,
      players: usersToAddToGroup.map((User user) => user.player).toList()
    );

    notifyListeners();

    return true;

    // final url = '$_url/create?firebaseId=${currentUser.firebaseId}';
    //
    // final data = <String, dynamic>{
    //   'currentUser': currentUser,
    //   'groupName': groupName,
    //   'usersToAddToGroup': usersToAddToGroup,
    // };
    //
    // final resp = await http.post(url,
    //     headers: {"Content-Type": "application/json"}, body: json.encode(data));
    //
    // final decodedData = json.decode(resp.body);
    //
    // if (decodedData['success']) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<bool> addPlayersToGroup(List<User> users, String chatRoomId) async {

    notifyListeners();

    return true;
    // final url = '$_url/addToChatRoom?apiKey=$_apiKey';
    //
    // final data = <String, dynamic>{'userToAdd': user, 'chatRoomId': chatRoomId};
    //
    // final resp = await http.post(
    //   url,
    //   headers: {"Content-Type": "application/json"},
    //   body: json.encode(data),
    // );
    //
    // final decodedData = json.decode(resp.body);
    //
    // if (decodedData['success'] != true) return false;
    //
    // notifyListeners();
    //
    // return true;
  }

  Future<bool> removePlayerFromGroup(User user, String chatRoomId) async {
    final url = '$_url/removeFromChatRoom?apiKey=$_apiKey';

    final data = <String, dynamic>{
      'userToRemove': user,
      'chatRoomId': chatRoomId
    };

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    final decodedData = json.decode(resp.body);

    if (decodedData['success'] != true) return false;

    notifyListeners();

    return true;
  }

  // Future<bool> addPlayerToGroup(User user, String chatRoomId) async {
  //   final url = '$_url/addToChatRoom?apiKey=$_apiKey';
  //
  //   final data = <String, dynamic>{'userToAdd': user, 'chatRoomId': chatRoomId};
  //
  //   print(json.encode(data));
  //
  //   final resp = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode(data),
  //   );
  //
  //   final decodedData = json.decode(resp.body);
  //
  //   if (decodedData['success'] != true) return false;
  //
  //   notifyListeners();
  //
  //   return true;
  // }

  Future<dynamic> editGroupName(
      ChatRoom chatRoom, String newChatRoomName) async {
    await Future.delayed(Duration(seconds: 1));
    chatRoom.name = newChatRoomName;
    notifyListeners();

    return {
      'success': true,
    };

    //RECUPERAR EL BACKEND DEL PENDRIVE

    // final url = '$_url/editGroupName?apiKey=$_apiKey';

    // final data = <String, dynamic>{
    //   'chatRoomToEdit': chatRoom,
    //   'newChatRoomName': newChatRoomName
    // };

    // final resp = await http.post(
    //   url,
    //   headers: {"Content-Type": "application/json"},
    //   body: json.encode(data),
    // );

    // final decodedData = json.decode(resp.body);

    // if (decodedData['response']['success'] != true) return false;

    // ChatRoom chatRoomUpdated =
    //     ChatRoom.fromJson(decodedData['response']['chatRoom']);

    // final response = {
    //   'success': decodedData['response']['success'],
    //   'chatRoom': chatRoomUpdated
    // };

    // notifyListeners();

    // return response;
  }

  Future<dynamic> editGroupDescription(
      ChatRoom chatRoom, String newChatRoomDesc) async {
    chatRoom.description = newChatRoomDesc;
    notifyListeners();

    return {
      'success': true,
    };
    // final url = '$_url/editGroupDescription?apiKey=$_apiKey';

    // final data = <String, dynamic>{
    //   'chatRoomToEdit': chatRoom,
    //   'newChatRoomDesc': newChatRoomDesc
    // };

    // final resp = await http.post(
    //   url,
    //   headers: {"Content-Type": "application/json"},
    //   body: json.encode(data),
    // );

    // final decodedData = json.decode(resp.body);

    // if (decodedData['response']['success'] != true) return false;

    // ChatRoom chatRoomUpdated =
    //     ChatRoom.fromJson(decodedData['response']['chatRoom']);

    // final response = {
    //   'success': decodedData['response']['success'],
    //   'chatRoom': chatRoomUpdated
    // };

    // notifyListeners();

    // return response;
  }

  Future<dynamic> editGroupImage(ChatRoom chatRoom, File groupImage) async {
    final url = '$_url/editGroupImage?apiKey=$_apiKey';

    String encodedImage = base64Encode(groupImage.readAsBytesSync());
    final data = <String, dynamic>{
      'chatRoomToEdit': chatRoom,
      'encodedImage': encodedImage
    };

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    final decodedData = json.decode(resp.body);

    if (decodedData['response']['success'] != true) return false;

    ChatRoom chatRoomUpdated =
        ChatRoom.fromJson(decodedData['response']['chatRoom']);

    final response = {
      'success': decodedData['response']['success'],
      'chatRoom': chatRoomUpdated
    };

    notifyListeners();

    return response;
  }
}
