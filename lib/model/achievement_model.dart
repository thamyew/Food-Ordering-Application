import 'dart:convert';

List<AchievementModel> achievementModelFromJson(String str) =>
    List<AchievementModel>.from(
        json.decode(str).map((x) => AchievementModel.fromJson(x)));

String achievementModelToJson(List<AchievementModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AchievementModel {
  AchievementModel({
    required this.achievementID,
    required this.achievementName,
    required this.achievementDesc,
    required this.achieved,
  });

  int achievementID;
  String achievementName;
  String achievementDesc;
  int achieved;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      AchievementModel(
        achievementID: json["achievement_id"],
        achievementName: json["achievement_name"],
        achievementDesc: json["achievement_desc"],
        achieved: json["achieved"],
      );

  Map<String, dynamic> toJson() => {
        "achievement_id": achievementID,
        'achievement_name': achievementName,
        'achievement_desc': achievementDesc,
        'achieved': achieved,
      };
}
