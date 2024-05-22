import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  final bool success;
  final String message;
  final Data data;

  RegisterModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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
  final User user;
  final Tokens tokens;

  Data({
    required this.user,
    required this.tokens,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        tokens: Tokens.fromJson(json["tokens"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "tokens": tokens.toJson(),
      };
}

class Tokens {
  final Access access;
  final Access refresh;

  Tokens({
    required this.access,
    required this.refresh,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        access: Access.fromJson(json["access"]),
        refresh: Access.fromJson(json["refresh"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access.toJson(),
        "refresh": refresh.toJson(),
      };
}

class Access {
  final String token;
  final DateTime expires;

  Access({
    required this.token,
    required this.expires,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        token: json["token"],
        expires: DateTime.parse(json["expires"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expires": expires.toIso8601String(),
      };
}

class User {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Location location;
  final DateTime dob;
  final String role;
  final String userImage;
  final bool isVerified;
  final bool isActive;
  final String deviceToken;
  final String deviceId;
  final String deviceType;
  final int offerRedeemed;
  final dynamic deletedAt;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.location,
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
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        location: Location.fromJson(json["location"]),
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
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "location": location.toJson(),
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
        "_id": id,
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
