import 'dart:convert';

List<OrderLineModel> orderLineModelFromJson(String str) =>
    List<OrderLineModel>.from(
        json.decode(str).map((x) => OrderLineModel.fromJson(x)));

String orderLineModelToJson(List<OrderLineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderLineModel {
  OrderLineModel({
    required this.foodId,
    required this.foodName,
    required this.foodQuantity,
    required this.foodPerPrice,
  });

  int foodId;
  String foodName;
  int foodQuantity;
  String foodPerPrice;

  factory OrderLineModel.fromJson(Map<String, dynamic> json) => OrderLineModel(
        foodId: json["food_id"],
        foodName: json["food_name"],
        foodQuantity: json["food_quantity"],
        foodPerPrice: json["food_per_price"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "food_name": foodName,
        "food_quantity": foodQuantity,
        "food_per_price": foodPerPrice,
      };
}
