import 'dart:convert';

SingleNote singleNoteFromJson(String str) =>
    SingleNote.fromJson(json.decode(str));

String singleNoteToJson(SingleNote data) => json.encode(data.toJson());

class SingleNote {
  bool success;
  String message;
  Data data;

  SingleNote({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SingleNote.fromJson(Map<String, dynamic> json) => SingleNote(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String title;
  String content;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Data({
    required this.id,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        createdBy: json["createdBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "createdBy": createdBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
