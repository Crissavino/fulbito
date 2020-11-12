import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fulbito/globals/environment.dart';
import 'package:fulbito/models/login_response.dart';
import 'package:fulbito/models/register_response.dart';
import 'package:fulbito/models/renew_token_response.dart';
import 'package:fulbito/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  User usuario;
  bool _autenticando = false;
  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // getters statics
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String pass) async {
    this.autenticando = true;

    final data = {"email": email, "password": pass};

    final resp = await http.post(
      '${Environment.apiUrl}/login',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      this.autenticando = false;
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      this.autenticando = false;
      return false;
    }
  }

  Future register(String nombre, String email, String pass) async {
    this.autenticando = true;

    final data = {
      "nombre": nombre,
      "email": email,
      "password": pass,
    };

    final resp = await http.post(
      '${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      this.autenticando = false;
      final registerResponse = registerResponseFromJson(resp.body);
      this.usuario = registerResponse.usuario;

      await this._guardarToken(registerResponse.token);

      return true;
    } else {
      this.autenticando = false;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    if (token == null) return false;

    final resp = await http.get(
      '${Environment.apiUrl}/login/renewToken',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (resp.statusCode == 200) {
      final renewTokenResponse = renewTokenResponseFromJson(resp.body);
      this.usuario = renewTokenResponse.usuario;

      await this._guardarToken(renewTokenResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
