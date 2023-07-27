import 'dart:convert';

List<CheckUsernameEmailModel> checkUsernameEmailModelFromJson(String str) =>
    List<CheckUsernameEmailModel>.from(
        json.decode(str).map((x) => CheckUsernameEmailModel.fromJson(x)));

String checkUsernameEmailModelToJson(List<CheckUsernameEmailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckUsernameEmailModel {
  CheckUsernameEmailModel({
    required this.statusCode,
    required this.statusMsg,
    required this.email,
  });

  int statusCode;
  String statusMsg;
  String email;

  factory CheckUsernameEmailModel.fromJson(Map<String, dynamic> json) =>
      CheckUsernameEmailModel(
        statusCode: json["statusCode"],
        statusMsg: json["statusMsg"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "statusMsg": statusMsg,
        "email": email,
      };
}
