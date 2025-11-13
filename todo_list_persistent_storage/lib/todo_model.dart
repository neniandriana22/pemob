import 'dart:convert';

class Todo {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Konversi dari Map ke Object (untuk membaca dari storage)
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      // Konversi string ISO 8601 kembali ke DateTime
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Konversi dari Object ke Map (untuk menyimpan ke storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      // Konversi DateTime ke string ISO 8601 untuk penyimpanan
      'createdAt': createdAt.toIso8601String(),
    };
  }
}