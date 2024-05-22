class MyOffersTypeModel {
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
  int? current;
  int? last;
  int? totalResults;
  int? limit;

  MyOffersTypeModel({
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
    this.current,
    this.last,
    this.totalResults,
    this.limit,
  });

  factory MyOffersTypeModel.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int lastPage,
    int totalResults,
    int limit,
  ) =>
      MyOffersTypeModel(
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
        current: currentPage,
        last: lastPage,
        totalResults: totalResults,
        limit: limit,
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
        "current": current,
        "last": last,
        "totalResults": totalResults,
        "limit": limit,
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
