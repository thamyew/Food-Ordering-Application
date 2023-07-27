import 'dart:convert';

List<CartOrderModel> cartOrderModelFromJson(String str) =>
    List<CartOrderModel>.from(
        json.decode(str).map((x) => CartOrderModel.fromJson(x)));

String cartOrderModelToJson(List<CartOrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartOrderModel {
  CartOrderModel({
    required this.foodId,
    required this.foodName,
    required this.foodQuantity,
    required this.foodPerPrice,
    required this.foodImgLocation,
  });

  int foodId;
  String foodName;
  int foodQuantity;
  String foodPerPrice;
  String foodImgLocation;

  factory CartOrderModel.fromJson(Map<String, dynamic> json) => CartOrderModel(
        foodId: json["food_id"],
        foodName: json["food_name"],
        foodQuantity: json["food_quantity"],
        foodPerPrice: json["food_per_price"],
        foodImgLocation: json["food_img_location"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "food_name": foodName,
        "food_quantity": foodQuantity,
        "food_per_price": foodPerPrice,
        "food_img_location": foodImgLocation,
      };
}
