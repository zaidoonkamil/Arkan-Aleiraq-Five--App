import 'dart:convert';

List<StatisticsModel> statisticsModelFromJson(String str) => List<StatisticsModel>.from(json.decode(str).map((x) => StatisticsModel.fromJson(x)));

String statisticsModelToJson(List<StatisticsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatisticsModel {
  int id;
  int userId;
  int variantId;
  int productId;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Product product;
  Variant variant;

  StatisticsModel({
    required this.id,
    required this.userId,
    required this.variantId,
    required this.productId,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.product,
    required this.variant,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) => StatisticsModel(
    id: json["id"],
    userId: json["user_id"],
    variantId: json["variant_id"],
    productId: json["product_id"],
    date: DateTime.parse(json["date"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
    product: Product.fromJson(json["product"]),
    variant: Variant.fromJson(json["variant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "variant_id": variantId,
    "product_id": productId,
    "date": date.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "product": product.toJson(),
    "variant": variant.toJson(),
  };
}

class Product {
  int id;
  String title;
  List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    images: List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": List<dynamic>.from(images.map((x) => x)),
  };
}

class User {
  int id;
  String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Variant {
  int id;
  int ProductCount;
  String? color;
  String? size;

  Variant({
    required this.id,
    required this.ProductCount,
    required this.color,
    required this.size,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    ProductCount: json["ProductCount"],
    color: json["color"]??'',
    size: json["size"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ProductCount": ProductCount,
    "color": color,
    "size": size,
  };
}
