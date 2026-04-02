// To parse this JSON data, do
//
//     final getProducts = getProductsFromJson(jsonString);

import 'dart:convert';

List<GetProducts> getProductsFromJson(String str) => List<GetProducts>.from(json.decode(str).map((x) => GetProducts.fromJson(x)));

String getProductsToJson(List<GetProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetProducts {
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

  GetProducts({
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

  factory GetProducts.fromJson(Map<String, dynamic> json) => GetProducts(
    id: json["id"],
    images: List<String>.from(json["images"].map((x) => x)).toSet().toList(),
    videoLinks: List<String>.from(json["videoLinks"].map((x) => x)),
    description: json["description"],
    size: json["size"],
    colors: json["colors"],
    attachedImages: List<String>.from(json["attachedImages"].map((x) => x)).toSet().toList(),
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
