class OfferSearchListModel {
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
  final List<dynamic> registrationQuestions;
  final DateTime createdAt;
  final DateTime updatedAt;
  int? current;
  int? last;
  int? totalResults;
  int? limit;

  OfferSearchListModel({
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
    this.current,
    this.last,
    this.totalResults,
    this.limit,
  });

  factory OfferSearchListModel.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int lastPage,
    int totalResults,
    int limit,
  ) =>
      OfferSearchListModel(
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
        registrationQuestions:
            List<dynamic>.from(json["registration_questions"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        current: currentPage,
        last: lastPage,
        totalResults: totalResults,
        limit: limit,
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
            List<dynamic>.from(registrationQuestions.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "current": current,
        "last": last,
        "totalResults": totalResults,
        "limit": limit,
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
