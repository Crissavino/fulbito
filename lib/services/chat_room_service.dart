import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/environment.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/device_message.dart';
import 'package:fulbito/models/player.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/users_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatRoomService with ChangeNotifier {
  final String _url = '$NGROK_HTTP/api/chatRooms';
  String _apiKey = 'cdf773c21cdd290fabe0618a20e4f181';
  ChatRoom _selectedChatRoom;
  List<ChatRoom> _allChatRooms = [];
  AuthService _authService = AuthService();

  ChatRoom get selectedChatRoom => this._selectedChatRoom;
  set selectedChatRoom(ChatRoom chatRoom) {
    this._selectedChatRoom = chatRoom;
    notifyListeners();
  }

  List<ChatRoom> get allChatRooms => this._allChatRooms;
  set allChatRooms(List<ChatRoom> chatRooms) {
    this._allChatRooms = chatRooms;
    notifyListeners();
  }

  Future<dynamic> createChatRoom(User currentUser, String groupName,
      List<User> usersToAddToGroup) async {

    try {
      final data = <String, dynamic>{
        'currentUser': currentUser,
        'groupName': groupName,
        'usersToAddToGroup': usersToAddToGroup,
      };

      final resp = await http.post(
          '${Environment.apiUrl}/chatRooms/create',
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          },
          body: json.encode(data)
      );

      final decodedData = json.decode(resp.body);

      if (decodedData['success']) {

        List<ChatRoom> newChatRooms = [];
        newChatRooms.addAll(this._allChatRooms);
        newChatRooms.add(ChatRoom.fromJson(decodedData['chatRoom']));

        this._allChatRooms = newChatRooms;

        return decodedData;

      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<ChatRoom>> getAllMyChatRooms(
    String userId,
  ) async {

    final List<String> deviceInformation = await AuthService.getDeviceDetails();
    final deviceID = deviceInformation[2];

    try {
      final resp = await http.get(
          '${Environment.apiUrl}/chatRooms/getAllMyChatRooms?userId=$userId&deviceId=$deviceID',
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          }
      );

      final Map<String, dynamic> decodedData = json.decode(resp.body);

      if (decodedData == null) return [];
      if (decodedData['error'] != null) return [];

      final chatRoomsFromNode = decodedData['chatRooms'];
      List<ChatRoom> chatRooms = List();

      chatRoomsFromNode.forEach((value) {
        final chatRoom = ChatRoom.fromJson(value);
        chatRooms.add(chatRoom);
      });

      return chatRooms;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<DeviceMessage>> getAllMyChatRoomMessages(
    String chatRoomId,
    String userId,
  ) async {
    try {
      final resp = await http.get(
          '${Environment.apiUrl}/chatRooms/getAllMyChatRoomMessage?userId=$userId&chatRoomId=$chatRoomId',
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          }
      );

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData == null) return [];
      if (decodedData['error'] != null) return [];

      final chatRoomMessagesFromNode = decodedData['deviceMessages'];
      List<DeviceMessage> messages = List();
      chatRoomMessagesFromNode.forEach((value) {
        final message = DeviceMessage.fromJson(value);
        messages.add(message);
      });

      return messages;

    } catch (e) {
      return [];
    }
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
