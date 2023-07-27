import 'dart:convert';

import 'package:food_ordering_application/model/cart_order_model.dart';

List<CartModel> cartModelFromJson(String str) =>
    List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  CartModel({
    required this.cartId,
    required this.cartOrders,
  });

  int cartId;
  List<CartOrderModel> cartOrders;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartId: json["cart_id"],
        cartOrders: cartOrderModelFromJson(jsonEncode(json["orders"])),
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "orders": cartOrderModelToJson(cartOrders),
      };
}
