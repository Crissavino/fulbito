import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fulbito/globals/environment.dart';
import 'package:fulbito/models/device.dart';
import 'package:fulbito/models/login_response.dart';
import 'package:fulbito/models/register_response.dart';
import 'package:fulbito/models/renew_token_response.dart';
import 'package:fulbito/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  User user;
  dynamic device;
  bool _authenticating = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get authenticating => this._authenticating;

  set authenticating(bool valor) {
    this._authenticating = valor;
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
    this.authenticating = true;

    final List<String> deviceInformation = await getDeviceDetails();

    final data = {
      "email": email,
      "password": pass,
      "deviceId": deviceInformation[2],
      "deviceType": Platform.isIOS ? 'ios' : 'android',
      "language": Platform.localeName,
    };

    final resp = await http.post(
      '${Environment.apiUrl}/auth',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      this.authenticating = false;
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      this.device = loginResponse.usuario.devices.where((dynamic device) {
        print(device['deviceId']);
        print(deviceInformation[2]);
        return device['deviceId'] == deviceInformation[2];
      }).first;

      return true;
    } else {
      this.authenticating = false;
      return false;
    }
  }

  Future register(String fullName, String email, String pass) async {
    this.authenticating = true;

    final List<String> deviceInformation = await getDeviceDetails();

    final data = {
      "fullName": fullName,
      "email": email,
      "password": pass,
      "type": Platform.isIOS ? 'ios' : 'android',
      "language": Platform.localeName,
      "deviceId": deviceInformation[2]
    };


    final resp = await http.post(
      '${Environment.apiUrl}/auth/create',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      this.authenticating = false;
      if (decodedData['success'] == false) {
        this.authenticating = false;
        return false;
      }
      final registerResponse = registerResponseFromJson(resp.body);
      this.user = registerResponse.user;
      this.device = registerResponse.user.devices.where((dynamic device) => device['deviceId'] == deviceInformation[2]).first;
      await this._guardarToken(registerResponse.token);

      return true;
    } else {
      this.authenticating = false;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    // final token = null;
    final List<String> deviceInformation = await getDeviceDetails();

    if (token == null) return false;

    final resp = await http.get(
      '${Environment.apiUrl}/auth/renewToken',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {

      final renewTokenResponse = renewTokenResponseFromJson(resp.body);
      // TODO controlar porque no lo procesa
      this.user = renewTokenResponse.user;
      this.device = renewTokenResponse.user.devices.where((dynamic device) => device['deviceId'] == deviceInformation[2]).first;
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

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        identifier = build.androidId; //UUID for Android
        deviceVersion = build.version.toString();
      } else if (Platform.isIOS) {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        identifier = data.identifierForVendor; //UUID for iOS
        deviceVersion = data.systemVersion;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    //if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }
}
