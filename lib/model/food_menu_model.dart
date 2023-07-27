import 'dart:convert';

List<FoodMenuModel> foodMenuModelFromJson(String str) =>
    List<FoodMenuModel>.from(
        json.decode(str).map((x) => FoodMenuModel.fromJson(x)));

String foodMenuModelToJson(List<FoodMenuModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodMenuModel {
  FoodMenuModel({
    required this.foodId,
    required this.foodName,
    required this.foodPrice,
    required this.foodRecommend,
    required this.foodImgLocation,
    required this.foodRating,
    required this.countRating,
  });

  int foodId;
  String foodName;
  String foodPrice;
  int foodRecommend;
  String foodImgLocation;
  double foodRating;
  int countRating;

  factory FoodMenuModel.fromJson(Map<String, dynamic> json) => FoodMenuModel(
        foodId: json["food_id"],
        foodName: json["food_name"],
        foodPrice: json["food_price"],
        foodRecommend: json["food_recommend"],
        foodImgLocation: json["img_location"],
        foodRating: json["food_rating"] + .0,
        countRating: json["num_of_rating"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "food_name": foodName,
        "food_price": foodPrice,
        "food_recommend": foodRecommend,
        "img_location": foodImgLocation,
        "food_rating": foodRating,
        "rating_count": countRating,
      };
}
