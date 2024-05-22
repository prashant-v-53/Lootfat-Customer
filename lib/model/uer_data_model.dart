import 'dart:convert';

UserDataModal userDataModalFromJson(String str) => UserDataModal.fromJson(json.decode(str));

String userDataModalToJson(UserDataModal data) => json.encode(data.toJson());

class UserDataModal {
  final bool success;
  final String message;
  final Data data;

  UserDataModal({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserDataModal.fromJson(Map<String, dynamic> json) => UserDataModal(
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
  final Location location;
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime dob;
  final String role;
  final String userImage;
  final bool isVerified;
  final bool isActive;
  final dynamic deviceToken;
  final dynamic deviceId;
  final dynamic deviceType;
  final int offerRedeemed;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({
    required this.location,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dob,
    required this.role,
    required this.userImage,
    required this.isVerified,
    required this.isActive,
    required this.deviceToken,
    required this.deviceId,
    required this.deviceType,
    required this.offerRedeemed,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        dob: DateTime.parse(json["dob"]),
        role: json["role"],
        userImage: json["user_image"],
        isVerified: json["isVerified"],
        isActive: json["isActive"],
        deviceToken: json["device_token"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        offerRedeemed: json["offer_redeemed"],
        deletedAt: json["deletedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "dob": dob.toIso8601String(),
        "role": role,
        "user_image": userImage,
        "isVerified": isVerified,
        "isActive": isActive,
        "device_token": deviceToken,
        "device_id": deviceId,
        "device_type": deviceType,
        "offer_redeemed": offerRedeemed,
        "deletedAt": deletedAt,
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
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
