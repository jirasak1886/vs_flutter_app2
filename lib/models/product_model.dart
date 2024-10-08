import 'dart:convert';

Productmodel productFromJson(String str) =>
    Productmodel.fromJson(json.decode(str));

String productToJson(Productmodel data) => json.encode(data.toJson());

class Productmodel {
  String id;
  String productName;
  String productType;
  int price;
  String unit;

  Productmodel({
    required this.id,
    required this.productName,
    required this.productType,
    required this.price,
    required this.unit,
  });

  factory Productmodel.fromJson(Map<String, dynamic> json) => Productmodel(
        id: json["_id"],
        productName: json["product_name"],
        productType: json["product_type"],
        price: json["price"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit,
      };
}
