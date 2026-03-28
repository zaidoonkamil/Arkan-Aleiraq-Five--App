// To parse this JSON data, do
//
//     final userStatusModel = userStatusModelFromJson(jsonString);

import 'dart:convert';

UserStatusModel userStatusModelFromJson(String str) => UserStatusModel.fromJson(json.decode(str));

String userStatusModelToJson(UserStatusModel data) => json.encode(data.toJson());

class UserStatusModel {
  List<User> users;

  UserStatusModel({
    required this.users,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) => UserStatusModel(
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  int id;
  String name;
  String phone;
  int totalTasks;
  int completedTasks;
  bool hasCompletedAll;
  List<Task> tasks;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalTasks,
    required this.completedTasks,
    required this.hasCompletedAll,
    required this.tasks,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    totalTasks: json["totalTasks"],
    completedTasks: json["completedTasks"],
    hasCompletedAll: json["hasCompletedAll"],
    tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "totalTasks": totalTasks,
    "completedTasks": completedTasks,
    "hasCompletedAll": hasCompletedAll,
    "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
  };
}

class Task {
  int id;
  int userId;
  int productId;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.userId,
    required this.productId,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    userId: json["userId"],
    productId: json["productId"],
    isCompleted: json["isCompleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "productId": productId,
    "isCompleted": isCompleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Product {
  int id;
  List<String> images;
  List<String> videoLinks;
  String description;
  String size;
  String colors;
  List<String> attachedImages;
  List<String> attachedVideos;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.id,
    required this.images,
    required this.videoLinks,
    required this.description,
    required this.size,
    required this.colors,
    required this.attachedImages,
    required this.attachedVideos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    images: List<String>.from(json["images"].map((x) => x)),
    videoLinks: List<String>.from(json["videoLinks"].map((x) => x)),
    description: json["description"],
    size: json["size"],
    colors: json["colors"],
    attachedImages: List<String>.from(json["attachedImages"].map((x) => x)),
    attachedVideos: List<String>.from(json["attachedVideos"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "images": List<dynamic>.from(images.map((x) => x)),
    "videoLinks": List<dynamic>.from(videoLinks.map((x) => x)),
    "description": description,
    "size": size,
    "colors": colors,
    "attachedImages": List<dynamic>.from(attachedImages.map((x) => x)),
    "attachedVideos": List<dynamic>.from(attachedVideos.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
