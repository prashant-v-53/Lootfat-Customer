import 'dart:convert';

BannersModel bannersModelFromJson(String str) => BannersModel.fromJson(json.decode(str));

String bannersModelToJson(BannersModel data) => json.encode(data.toJson());

class BannersModel {
  final bool success;
  final String message;
  final List<Datum> data;

  BannersModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String id;
  final CreatedBy createdBy;
  final String title;
  final String description;
  final bool verifiedByAdmin;
  final String bannerImage;
  final DateTime fromDate;
  final DateTime toDate;
  final int index;
  final bool isActive;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Datum({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.verifiedByAdmin,
    required this.bannerImage,
    required this.fromDate,
    required this.toDate,
    required this.index,
    required this.isActive,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        title: json["title"],
        description: json["description"],
        verifiedByAdmin: json["verified_by_admin"],
        bannerImage: json["banner_image"],
        fromDate: DateTime.parse(json["from_date"]),
        toDate: DateTime.parse(json["to_date"]),
        index: json["index"],
        isActive: json["is_active"],
        deletedAt: json["deletedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy.toJson(),
        "title": title,
        "description": description,
        "verified_by_admin": verifiedByAdmin,
        "banner_image": bannerImage,
        "from_date": fromDate.toIso8601String(),
        "to_date": toDate.toIso8601String(),
        "index": index,
        "is_active": isActive,
        "deletedAt": deletedAt,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class CreatedBy {
  final String id;
  final String firstName;
  final String lastName;

  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
      };
}
