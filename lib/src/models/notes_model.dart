import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  bool success;
  String message;
  List<Datum> data;

  Note({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String title;
  String content;

  Datum({
    required this.title,
    required this.content,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}
