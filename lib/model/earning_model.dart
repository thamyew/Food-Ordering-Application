import 'dart:convert';

List<EarningModel> earningModelFromJson(String str) => List<EarningModel>.from(
    json.decode(str).map((x) => EarningModel.fromJson(x)));

String earningModelToJson(List<EarningModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EarningModel {
  EarningModel({
    required this.earningDate,
    required this.total,
  });

  String earningDate;
  String total;

  factory EarningModel.fromJson(Map<String, dynamic> json) => EarningModel(
        earningDate: json["earning_date"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "earning_date": earningDate,
        'total': total,
      };
}
