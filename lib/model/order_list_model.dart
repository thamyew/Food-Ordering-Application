import 'dart:convert';

import 'package:food_ordering_application/model/order_line_model.dart';

List<OrderListModel> orderListModelFromJson(String str) =>
    List<OrderListModel>.from(
        json.decode(str).map((x) => OrderListModel.fromJson(x)));

String orderListModelToJson(List<OrderListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderListModel {
  OrderListModel({
    required this.orderId,
    required this.orderDateTime,
    required this.orderStatus,
    required this.orderTotal,
    required this.orderCustomerUsername,
    required this.orderRemark,
    required this.orders,
  });

  int orderId;
  String orderDateTime;
  int orderStatus;
  String orderTotal;
  String orderCustomerUsername;
  String orderRemark;
  List<OrderLineModel> orders;

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        orderId: json["order_id"],
        orderDateTime: json["order_date_time"],
        orderStatus: json["order_status"],
        orderTotal: json["order_total"],
        orderCustomerUsername: json["customer_username"],
        orderRemark: json["order_remark"],
        orders: orderLineModelFromJson(jsonEncode(json["order_lines"])),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        'order_date_time': orderDateTime,
        'order_status': orderStatus,
        'order_total': orderTotal,
        'customer_username': orderCustomerUsername,
        'order_remark': orderRemark,
        "order_lines": orderLineModelToJson(orders),
      };
}
