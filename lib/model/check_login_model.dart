import 'dart:convert';

List<CheckLoginModel> checkLoginModelFromJson(String str) =>
    List<CheckLoginModel>.from(
        json.decode(str).map((x) => CheckLoginModel.fromJson(x)));

String checkLoginModelToJson(List<CheckLoginModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckLoginModel {
  CheckLoginModel({
    required this.statusCode,
    required this.username,
    required this.level,
    required this.cartId,
  });

  int statusCode;
  String username;
  int level;
  int cartId;

  factory CheckLoginModel.fromJson(Map<String, dynamic> json) =>
      CheckLoginModel(
        statusCode: json["statusCode"],
        username: json["username"],
        level: json["level"],
        cartId: json["cart_id"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "username": username,
        "level": level,
        "cart_id": cartId,
      };
}
