class UserRedeemListModel {
  final String id;
  final String createdBy;
  final Shop shop;
  final String title;
  final String offerType;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final int offerPrice;
  final int offerPercentage;
  final DateTime createdAt;
  final int redeemCount;
  final String offerImage;
  int? current;
  int? last;
  int? totalResults;
  int? limit;

  UserRedeemListModel({
    required this.id,
    required this.createdBy,
    required this.shop,
    required this.title,
    required this.offerType,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.createdAt,
    required this.redeemCount,
    required this.offerImage,
    this.current,
    this.last,
    this.totalResults,
    this.limit,
  });

  factory UserRedeemListModel.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int lastPage,
    int totalResults,
    int limit,
  ) =>
      UserRedeemListModel(
        id: json["_id"],
        createdBy: json["created_by"],
        shop: Shop.fromJson(json["shop"]),
        title: json["title"],
        offerType: json["offer_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        offerPrice: json["offer_price"],
        offerPercentage: json["offer_percentage"],
        createdAt: DateTime.parse(json["createdAt"]),
        redeemCount: json["redeemCount"],
        offerImage: json["offer_image"],
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
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "price": price,
        "offer_price": offerPrice,
        "offer_percentage": offerPercentage,
        "createdAt": createdAt.toIso8601String(),
        "redeemCount": redeemCount,
        "offer_image": offerImage,
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
