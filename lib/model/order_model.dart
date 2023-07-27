import 'dart:convert';

import 'package:food_ordering_application/model/order_line_model.dart';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
    required this.orderId,
    required this.orderDateTime,
    required this.orderStatus,
    required this.orderSubtotal,
    required this.orderTotal,
    required this.orderCustomerUsername,
    required this.orderRemark,
    required this.orderArchived,
    required this.orderArchivedExpiryDate,
    required this.orders,
    required this.orderFeedback,
  });

  int orderId;
  String orderDateTime;
  int orderStatus;
  String orderSubtotal;
  String orderTotal;
  String orderCustomerUsername;
  String orderRemark;
  int orderArchived;
  String orderArchivedExpiryDate;
  List<OrderLineModel> orders;
  String orderFeedback;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["order_id"],
        orderDateTime: json["order_date_time"],
        orderStatus: json["order_status"],
        orderSubtotal: json["order_subtotal"],
        orderTotal: json["order_total"],
        orderCustomerUsername: json["customer_username"],
        orderRemark: json["order_remark"],
        orderArchived: json["order_archived"],
        orderArchivedExpiryDate: json["archived_expiry_date"],
        orders: orderLineModelFromJson(jsonEncode(json["order_lines"])),
        orderFeedback: json["order_feedback"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        'order_date_time': orderDateTime,
        'order_status': orderStatus,
        'order_subtotal': orderSubtotal,
        'order_total': orderTotal,
        'customer_username': orderCustomerUsername,
        'order_remark': orderRemark,
        'order_archived': orderArchived,
        'archived_expiry_date': orderArchivedExpiryDate,
        'order_lines': orderLineModelToJson(orders),
        'order_feedback': orderFeedback,
      };
}
