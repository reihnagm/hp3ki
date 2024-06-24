import 'dart:convert';

ShopDetailModel shopDetailModelFromJson(String str) =>
    ShopDetailModel.fromJson(json.decode(str));

String shopDetailModelToJson(ShopDetailModel data) =>
    json.encode(data.toJson());

class ShopDetailModel {
  String id;
  String owner;
  String name;
  int price;
  int weight;
  List<Picture> pictures;
  String description;
  int stock;
  bool isOutStock;
  int minOrder;
  Condition condition;
  Category category;
  Review review;
  Store store;

  ShopDetailModel({
    required this.id,
    required this.owner,
    required this.name,
    required this.price,
    required this.weight,
    required this.pictures,
    required this.description,
    required this.stock,
    required this.isOutStock,
    required this.minOrder,
    required this.condition,
    required this.category,
    required this.review,
    required this.store,
  });

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) =>
      ShopDetailModel(
        id: json["id"],
        owner: json["owner"],
        name: json["name"],
        price: json["price"],
        weight: json["weight"],
        pictures: List<Picture>.from(
            json["pictures"].map((x) => Picture.fromJson(x))),
        description: json["description"],
        stock: json["stock"],
        isOutStock: json["is_out_stock"],
        minOrder: json["min_order"],
        condition: Condition.fromJson(json["condition"]),
        category: Category.fromJson(json["category"]),
        review: Review.fromJson(json["review"]),
        store: Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "name": name,
        "price": price,
        "weight": weight,
        "pictures": List<dynamic>.from(pictures.map((x) => x.toJson())),
        "description": description,
        "stock": stock,
        "is_out_stock": isOutStock,
        "min_order": minOrder,
        "condition": condition.toJson(),
        "category": category.toJson(),
        "review": review.toJson(),
        "store": store.toJson(),
      };
}

class Category {
  String id;
  String name;
  String type;

  Category({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
      };
}

class Condition {
  String id;
  String name;

  Condition({
    required this.id,
    required this.name,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Picture {
  String path;

  Picture({
    required this.path,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
      };
}

class Review {
  String id;
  String rating;
  int total;

  Review({
    required this.id,
    required this.rating,
    required this.total,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        rating: json["rating"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "total": total,
      };
}

class Store {
  String id;
  String name;
  String picture;
  String description;
  String city;

  Store({
    required this.id,
    required this.name,
    required this.picture,
    required this.description,
    required this.city,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
      id: json["id"],
      name: json["name"],
      picture: json["picture"],
      description: json["description"],
      city: json["city"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picture": picture,
        "description": description,
        "city": city
      };
}
