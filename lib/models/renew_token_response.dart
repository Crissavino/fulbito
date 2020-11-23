// To parse this JSON data, do
//
//     final renewTokenResponse = renewTokenResponseFromJson(jsonString);

import 'dart:convert';

import 'package:fulbito/models/user.dart';

RenewTokenResponse renewTokenResponseFromJson(String str) =>
    RenewTokenResponse.fromJson(json.decode(str));

String renewTokenResponseToJson(RenewTokenResponse data) =>
    json.encode(data.toJson());

class RenewTokenResponse {
  RenewTokenResponse({
    this.ok,
    this.user,
    this.token,
  });

  bool ok;
  User user;
  String token;

  factory RenewTokenResponse.fromJson(Map<String, dynamic> json) {
    return RenewTokenResponse(
          ok: json["ok"],
          user: User.fromJson(json["user"]),
          token: json["token"],
        );
  }

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user.toJson(),
        "token": token,
      };
}
