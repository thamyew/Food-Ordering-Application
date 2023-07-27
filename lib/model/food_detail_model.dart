import 'dart:convert';

List<FoodDetailModel> foodDetailModelFromJson(String str) =>
    List<FoodDetailModel>.from(
        json.decode(str).map((x) => FoodDetailModel.fromJson(x)));

String foodDetailModelToJson(List<FoodDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodDetailModel {
  FoodDetailModel({
    required this.foodId,
    required this.foodName,
    required this.foodDesc,
    required this.foodPrice,
    required this.foodRecommend,
    required this.foodArchived,
    required this.foodArchivedExpDate,
    required this.foodImgId,
    required this.foodImgLocation,
    required this.foodRating,
    required this.countRating,
  });

  int foodId;
  String foodName;
  String foodDesc;
  String foodPrice;
  int foodRecommend;
  int foodArchived;
  String foodArchivedExpDate;
  int foodImgId;
  String foodImgLocation;
  double foodRating;
  int countRating;

  factory FoodDetailModel.fromJson(Map<String, dynamic> json) =>
      FoodDetailModel(
        foodId: json["food_id"],
        foodName: json["food_name"],
        foodDesc: json["food_desc"],
        foodPrice: json["food_price"],
        foodRecommend: json["food_recommend"],
        foodArchived: json["food_archived"],
        foodArchivedExpDate: json["food_archive_expiry_date"],
        foodImgId: json["food_img_id"],
        foodImgLocation: json["img_location"],
        foodRating: json["food_rating"] + .0,
        countRating: json["num_of_rating"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "food_name": foodName,
        "food_desc": foodDesc,
        "food_price": foodPrice,
        "food_recommend": foodRecommend,
        "food_archived": foodArchived,
        "food_archive_expiry_date": foodArchivedExpDate,
        "img_location": foodImgLocation,
        "food_img_id": foodImgId,
        "food_rating": foodRating,
        "rating_count": countRating,
      };
}
