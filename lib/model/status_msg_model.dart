import 'dart:convert';

List<StatusMsgModel> statusMsgModelFromJson(String str) =>
    List<StatusMsgModel>.from(
        json.decode(str).map((x) => StatusMsgModel.fromJson(x)));

String statusMsgModelToJson(List<StatusMsgModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusMsgModel {
  StatusMsgModel({
    required this.statusCode,
    required this.statusMsg,
  });

  int statusCode;
  String statusMsg;

  factory StatusMsgModel.fromJson(Map<String, dynamic> json) => StatusMsgModel(
        statusCode: json["statusCode"],
        statusMsg: json["statusMsg"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "statusMsg": statusMsg,
      };
}
