import 'GetProducts.dart';

class DailyTaskModel {
  int id;
  int userId;
  int productId;
  List<String> downloadedMedia;
  bool isCompleted;
  GetProducts? product;
  DateTime createdAt;

  DailyTaskModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.downloadedMedia,
    required this.isCompleted,
    this.product,
    required this.createdAt,
  });

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) => DailyTaskModel(
    id: json["id"] ?? 0,
    userId: json["userId"] ?? 0,
    productId: json["productId"] ?? 0,
    downloadedMedia: json["downloadedMedia"] != null ? List<String>.from(json["downloadedMedia"].map((x) => x)) : [],
    isCompleted: json["isCompleted"] ?? false,
    product: json["product"] != null ? GetProducts.fromJson(json["product"]) : null,
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
  );
}
