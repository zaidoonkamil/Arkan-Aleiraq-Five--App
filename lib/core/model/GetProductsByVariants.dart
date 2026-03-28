import 'dart:convert';

List<GetProductsByVariants> getProductsByVariantsFromJson(String str) => List<GetProductsByVariants>.from(json.decode(str).map((x) => GetProductsByVariants.fromJson(x)));

String getProductsByVariantsToJson(List<GetProductsByVariants> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetProductsByVariants {
  int id;
  String title;
  String videoUrl;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;
  List<Variant> variants;

  GetProductsByVariants({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.variants,
  });

  factory GetProductsByVariants.fromJson(Map<String, dynamic> json) => GetProductsByVariants(
    id: json["id"],
    title: json["title"],
    videoUrl: json["videoUrl"],
    images: List<String>.from(json["images"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    variants: List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "videoUrl": videoUrl,
    "images": List<dynamic>.from(images.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
  };
}

class Variant {
  int id;
  int ProductCount;
  String color;
  String size;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int productId;
  Creator creator;
  Preparer? preparer;

  Variant({
    required this.id,
    required this.ProductCount,
    required this.color,
    required this.size,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.productId,
    required this.creator,
    required this.preparer,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    ProductCount: json["ProductCount"],
    color: json["color"],
    size: json["size"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    productId: json["product_id"],
    creator: Creator.fromJson(json["creator"]),
    preparer: json["preparer"] != null
        ? Preparer.fromJson(json["preparer"])
        : null,  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ProductCount": ProductCount,
    "color": color,
    "size": size,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "product_id": productId,
    "creator": creator.toJson(),
  };
}

class Creator {
  int id;
  String name;

  Creator({
    required this.id,
    required this.name,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Preparer {
  int id;
  String name;

  Preparer({
    required this.id,
    required this.name,
  });

  factory Preparer.fromJson(Map<String, dynamic> json) => Preparer(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
