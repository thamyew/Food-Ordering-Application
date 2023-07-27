import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    required this.username,
    required this.email,
    required this.name,
    required this.gender,
    required this.address,
    required this.phoneNum,
    required this.profilePicId,
    required this.statusMsg,
  });

  String username;
  String email;
  String name;
  String gender;
  String address;
  String phoneNum;
  String profilePicId;
  String statusMsg;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      username: json["username"],
      email: json["email"],
      name: json["name"],
      gender: json["gender"],
      address: json["address"],
      phoneNum: json["phone_num"],
      profilePicId: json["profile_pic_id"],
      statusMsg: json["statusMsg"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "name": name,
        "gender": gender,
        "address": address,
        "phone_num": phoneNum,
        "profile_pic_id": profilePicId,
        "statusMsg": statusMsg,
      };
}
