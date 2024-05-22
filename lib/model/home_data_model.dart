import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  final bool success;
  final String message;
  final Data data;

  HomeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  final List<HomeOfferModel> nearBy;
  final List<HomeOfferModel> trending;
  final List<HomeOfferModel> newArrival;
  final List<HomeOfferModel> expireSoon;
  final List<HomeOfferModel> limited;

  Data({
    required this.nearBy,
    required this.trending,
    required this.newArrival,
    required this.expireSoon,
    required this.limited,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nearBy: List<HomeOfferModel>.from(json["near_by"].map((x) => HomeOfferModel.fromJson(x))),
        trending:
            List<HomeOfferModel>.from(json["trending"].map((x) => HomeOfferModel.fromJson(x))),
        newArrival:
            List<HomeOfferModel>.from(json["new_arrival"].map((x) => HomeOfferModel.fromJson(x))),
        expireSoon:
            List<HomeOfferModel>.from(json["expire_soon"].map((x) => HomeOfferModel.fromJson(x))),
        limited: List<HomeOfferModel>.from(json["limited"].map((x) => HomeOfferModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "near_by": List<dynamic>.from(nearBy.map((x) => x.toJson())),
        "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
        "new_arrival": List<dynamic>.from(newArrival.map((x) => x.toJson())),
        "expire_soon": List<dynamic>.from(expireSoon.map((x) => x.toJson())),
        "limited": List<dynamic>.from(limited.map((x) => x.toJson())),
      };
}

class HomeOfferModel {
  final String id;
  final String createdBy;
  final Shop shop;
  final String title;
  final String offerType;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final int offerPrice;
  final int offerPercentage;
  final String qrCode;
  final bool isActive;
  final int redeemedCount;
  final DateTime createdAt;
  final String offerImage;
  final String startTime;
  final String endTime;

  HomeOfferModel({
    required this.id,
    required this.createdBy,
    required this.shop,
    required this.title,
    required this.offerType,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.qrCode,
    required this.isActive,
    required this.redeemedCount,
    required this.createdAt,
    required this.offerImage,
    required this.startTime,
    required this.endTime,
  });

  factory HomeOfferModel.fromJson(Map<String, dynamic> json) => HomeOfferModel(
        id: json["_id"],
        createdBy: json["created_by"],
        shop: Shop.fromJson(json["shop"]),
        title: json["title"],
        offerType: json["offer_type"],
        description: json["description"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        offerPrice: json["offer_price"],
        offerPercentage: json["offer_percentage"],
        qrCode: json["qr_code"],
        isActive: json["is_active"],
        redeemedCount: json["redeemed_count"],
        createdAt: DateTime.parse(json["createdAt"]),
        offerImage: json["offer_image"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy,
        "shop": shop.toJson(),
        "title": title,
        "offer_type": offerType,
        "description": description,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "price": price,
        "offer_price": offerPrice,
        "offer_percentage": offerPercentage,
        "qr_code": qrCode,
        "is_active": isActive,
        "redeemed_count": redeemedCount,
        "createdAt": createdAt.toIso8601String(),
        "offer_image": offerImage,
        "start_time": startTime,
        "end_time": endTime,
      };
}

class Shop {
  final String id;
  final String shopName;

  Shop({
    required this.id,
    required this.shopName,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["_id"],
        shopName: json["shop_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "shop_name": shopName,
      };
}
