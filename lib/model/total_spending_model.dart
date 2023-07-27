import 'dart:convert';

List<TotalSpendingModel> totalSpendingModelFromJson(String str) =>
    List<TotalSpendingModel>.from(
        json.decode(str).map((x) => TotalSpendingModel.fromJson(x)));

String totalSpendingModelToJson(List<TotalSpendingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TotalSpendingModel {
  TotalSpendingModel({
    required this.total,
    required this.customerUsername,
  });

  String total;
  String customerUsername;

  factory TotalSpendingModel.fromJson(Map<String, dynamic> json) =>
      TotalSpendingModel(
        total: json["total_spending"],
        customerUsername: json["customer_username"],
      );

  Map<String, dynamic> toJson() => {
        'total_spending': total,
        'customer_username': customerUsername,
      };
}
