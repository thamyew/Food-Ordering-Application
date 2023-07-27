import 'dart:convert';

List<ArchivedFoodMenuModel> archivedFoodMenuModelFromJson(String str) =>
    List<ArchivedFoodMenuModel>.from(
        json.decode(str).map((x) => ArchivedFoodMenuModel.fromJson(x)));

String archivedFoodMenuModelToJson(List<ArchivedFoodMenuModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArchivedFoodMenuModel {
  ArchivedFoodMenuModel({
    required this.foodId,
    required this.foodName,
    required this.foodPrice,
    required this.foodRecommend,
    required this.foodArchivedExpiryDate,
    required this.foodImgLocation,
  });

  int foodId;
  String foodName;
  String foodPrice;
  int foodRecommend;
  String foodArchivedExpiryDate;
  String foodImgLocation;

  factory ArchivedFoodMenuModel.fromJson(Map<String, dynamic> json) =>
      ArchivedFoodMenuModel(
        foodId: json["foodId"],
        foodName: json["foodName"],
        foodPrice: json["foodPrice"],
        foodRecommend: json["foodRecommend"],
        foodArchivedExpiryDate: json['foodArchiveExpiryDate'],
        foodImgLocation: json["foodImgLocation"],
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "foodName": foodName,
        "foodPrice": foodPrice,
        "foodRecommend": foodRecommend,
        "foodArchiveExpiryDate": foodArchivedExpiryDate,
        "foodImgLocation": foodImgLocation,
      };
}
