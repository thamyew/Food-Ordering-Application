import 'dart:convert';

List<ImageModel> imageModelFromJson(String str) =>
    List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String imageModelToJson(List<ImageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
  ImageModel({
    required this.statusCode,
    required this.imgId,
    required this.filename,
    required this.path,
  });

  int statusCode;
  int imgId;
  String filename;
  String path;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        statusCode: json["statusCode"],
        imgId: json["profile_pic_id"],
        filename: json["filename"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "profile_pic_id": imgId,
        "filename": filename,
        "path": path,
      };
}
