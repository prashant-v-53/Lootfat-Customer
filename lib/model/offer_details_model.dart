import 'dart:convert';

MyOffersDetailsModel myOffersDetailsModelFromJson(String str) =>
    MyOffersDetailsModel.fromJson(json.decode(str));

String myOffersDetailsModelToJson(MyOffersDetailsModel data) =>
    json.encode(data.toJson());

class MyOffersDetailsModel {
  final String id;
  final String createdBy;
  final Shop shop;
  final String title;
  final String offerType;
  final String description;
  final String offerImage;
  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String endTime;
  final int price;
  final int offerPrice;
  final int offerPercentage;
  final String qrCode;
  final bool isActive;
  final int redeemedCount;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MyOffersDetailsModel({
    required this.id,
    required this.createdBy,
    required this.shop,
    required this.title,
    required this.offerType,
    required this.description,
    required this.offerImage,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.qrCode,
    required this.isActive,
    required this.redeemedCount,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyOffersDetailsModel.fromJson(Map<String, dynamic> json) =>
      MyOffersDetailsModel(
        id: json["_id"],
        createdBy: json["created_by"],
        shop: Shop.fromJson(json["shop"]),
        title: json["title"],
        offerType: json["offer_type"],
        description: json["description"],
        offerImage: json["offer_image"],
        startDate: DateTime.parse(json["start_date"]),
        startTime: json["start_time"],
        endDate: DateTime.parse(json["end_date"]),
        endTime: json["end_time"],
        price: json["price"],
        offerPrice: json["offer_price"],
        offerPercentage: json["offer_percentage"],
        qrCode: json["qr_code"],
        isActive: json["is_active"],
        redeemedCount: json["redeemed_count"],
        deletedAt: json["deletedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy,
        "shop": shop.toJson(),
        "title": title,
        "offer_type": offerType,
        "description": description,
        "offer_image": offerImage,
        "start_date": startDate.toIso8601String(),
        "start_time": startTime,
        "end_date": endDate.toIso8601String(),
        "end_time": endTime,
        "price": price,
        "offer_price": offerPrice,
        "offer_percentage": offerPercentage,
        "qr_code": qrCode,
        "is_active": isActive,
        "redeemed_count": redeemedCount,
        "deletedAt": deletedAt,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Shop {
  final Location location;
  final String id;
  final String user;
  final String shopName;
  final String shopNumber;
  final String landMark;
  final String city;
  final String country;
  final String postalCode;
  final String qrCode;
  final bool isActive;
  final dynamic deletedAt;
  final List<RegistrationQuestion> registrationQuestions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop({
    required this.location,
    required this.id,
    required this.user,
    required this.shopName,
    required this.shopNumber,
    required this.landMark,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.qrCode,
    required this.isActive,
    required this.deletedAt,
    required this.registrationQuestions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        user: json["user"],
        shopName: json["shop_name"],
        shopNumber: json["shop_number"],
        landMark: json["land_mark"],
        city: json["city"],
        country: json["country"],
        postalCode: json["postal_code"],
        qrCode: json["qr_code"],
        isActive: json["isActive"],
        deletedAt: json["deletedAt"],
        registrationQuestions: List<RegistrationQuestion>.from(
            json["registration_questions"]
                .map((x) => RegistrationQuestion.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "user": user,
        "shop_name": shopName,
        "shop_number": shopNumber,
        "land_mark": landMark,
        "city": city,
        "country": country,
        "postal_code": postalCode,
        "qr_code": qrCode,
        "isActive": isActive,
        "deletedAt": deletedAt,
        "registration_questions":
            List<dynamic>.from(registrationQuestions.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class RegistrationQuestion {
  final String question;
  final List<String> answer;
  final String id;

  RegistrationQuestion({
    required this.question,
    required this.answer,
    required this.id,
  });

  factory RegistrationQuestion.fromJson(Map<String, dynamic> json) =>
      RegistrationQuestion(
        question: json["question"],
        answer: List<String>.from(json["answer"].map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": List<dynamic>.from(answer.map((x) => x)),
        "_id": id,
      };
}
