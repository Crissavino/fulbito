import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
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
    await Future.delayed(Duration(seconds: 1));

    List<User> users = [
      User(
        id: '1',
        fullName: 'Cris1',
      ),
      User(
        id: '2',
        fullName: 'Cris2',
      ),
      User(
        id: '3',
        fullName: 'Cris3',
      ),
      User(
        id: '4',
        fullName: 'Cris4',
      ),
      User(
        id: '5',
        fullName: 'Cris5',
      ),
      User(
        id: '6',
        fullName: 'Cris6',
      ),
      User(
        id: '7',
        fullName: 'Cris7',
      ),
      User(
        id: '8',
        fullName: 'Cris8',
      ),
      User(
        id: '9',
        fullName: 'Cris8',
      ),
      User(
        id: '10',
        fullName: 'Cris8',
      ),
      User(
        id: '11',
        fullName: 'Cris8',
      ),
      User(
        id: '12',
        fullName: 'Cris8',
      ),
      User(
        id: '13',
        fullName: 'Cris8',
      ),
      User(
        id: '8',
        fullName: 'Cris8',
      ),
      User(
        id: '8',
        fullName: 'Cris8',
      )
    ];
    return users;
    // final url = '$_url/getAllUsers';
    // final resp = await http.get(url);

    // final Map<String, dynamic> decodedData = json.decode(resp.body);
    // if (decodedData == null) return [];
    // if (decodedData['error'] != null) return [];

    // final usersFromNode = decodedData['users'];
    // List<User> users = List();

    // usersFromNode.forEach((value) {
    //   final user = User.fromJson(value);
    //   users.add(user);
    // });
    // return users;
  }
}
