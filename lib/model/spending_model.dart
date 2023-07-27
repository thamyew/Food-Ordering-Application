import 'dart:convert';

List<SpendingModel> spendingModelFromJson(String str) =>
    List<SpendingModel>.from(
        json.decode(str).map((x) => SpendingModel.fromJson(x)));

String spendingModelToJson(List<SpendingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpendingModel {
  SpendingModel({
    required this.spendingDate,
    required this.customerUsername,
    required this.total,
  });

  String spendingDate;
  String customerUsername;
  String total;

  factory SpendingModel.fromJson(Map<String, dynamic> json) => SpendingModel(
        spendingDate: json["spending_date"],
        customerUsername: json["customer_username"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "spending_date": spendingDate,
        'customer_username': customerUsername,
        'total': total,
      };
}
