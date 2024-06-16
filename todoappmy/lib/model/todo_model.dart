// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  int? id;
  String? text;
  int? complete;
  DateTime? createdAt;
  DateTime? updatedAt;

  Todo({
    required this.id,
    required this.text,
    required this.complete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        text: json["text"],
        complete: json["complete"],
        createdAt: DateTime.parse(json["created_at"].toString()),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "complete": complete,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
