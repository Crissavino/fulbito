import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/environment.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:fulbito/models/user.dart';

class UsersService with ChangeNotifier {
  final String _url = '$NGROK_HTTP/api';
  List<User> _selectedSearchedUsers = [];
  String _termSearched;

  get selectedSearchedUsers => this._selectedSearchedUsers;

  set selectedSearchedUsers(User userToAdd) {
    this._selectedSearchedUsers.add(userToAdd);
    notifyListeners();
  }

  removeSelectedUser(User userToRemove){
    this._selectedSearchedUsers.removeWhere((user) => user.id == userToRemove.id);
    notifyListeners();
  }

  emptySelectedUsersArray(){
    this._selectedSearchedUsers.clear();
  }

  String get termSearched => this._termSearched;

  set termSearched(String term) {
    this._termSearched = term;
    notifyListeners();
  }

  Future<List<User>> getAllUsers() async {
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/users/getAllUsers',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        },
      );

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData == null) return [];
      if (decodedData['error'] != null) return [];

      final usersFromNode = decodedData['users'];
      List<User> users = List();

      usersFromNode.forEach((value) {
        final user = User.fromJson(value);
        users.add(user);
      });

      return users;
    } catch (e) {
      return [];
    }
  }
}
