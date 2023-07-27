import 'dart:convert';

List<FeedbackModel> feedbackModelFromJson(String str) =>
    List<FeedbackModel>.from(
        json.decode(str).map((x) => FeedbackModel.fromJson(x)));

String feedbackModelToJson(List<FeedbackModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackModel {
  FeedbackModel({
    required this.feedbackId,
    required this.content,
    required this.date,
  });

  int feedbackId;
  String content;
  String date;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        feedbackId: json["feedback_id"],
        content: json["content"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "feedback_id": feedbackId,
        "content": content,
        "date": date,
      };
}
