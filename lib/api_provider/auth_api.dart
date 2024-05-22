import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../res/url.dart';
import '../utils/utils.dart';

class AuthAPI {
  static Future<http.Response> signUpUser(String mobileNumber, firstName, lastName, dob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deviceType = prefs.getString('deviceType');
    var deviceId = prefs.getString('deviceID');
    var deviceToken = prefs.getString('deviceToken');

    print({
      "type": "user",
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": mobileNumber,
      "latitude": "21.1702",
      "longitude": "72.8311",
      "device_token": deviceToken,
      "device_id": deviceId,
      "device_type": deviceType,
      "dob": dob,
    });
    return await http
        .post(Uri.parse('${AppUrl.baseUrl}auth/register'), body: {
          "type": "user",
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": mobileNumber,
          "latitude": "21.1702",
          "longitude": "72.8311",
          "device_token": deviceToken,
          "device_id": deviceId,
          "device_type": deviceType,
          "dob": dob,
        })
        .catchError(
          (e) => http.Response("$e", 555),
        )
        .timeout(
          Duration(seconds: Utils.timeoutSecondsApi),
          onTimeout: () => Future.value(
            http.Response("Request Timeout", 001),
          ),
        );
  }

  static Future<http.Response> loginUser(String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deviceType = prefs.getString('deviceType');
    var deviceId = prefs.getString('deviceID');
    var deviceToken = prefs.getString('deviceToken');
    print(deviceType);
    print(deviceId);
    print(deviceId);

    return await http
        .post(Uri.parse('${AppUrl.baseUrl}auth/login'), body: {
          "phone_number": mobileNumber,
          "device_token": deviceToken,
          "device_id": deviceId,
          "device_type": deviceType,
        })
        .catchError(
          (e) => http.Response("$e", 001),
        )
        .timeout(
          Duration(seconds: Utils.timeoutSecondsApi),
          onTimeout: () => Future.value(
            http.Response("Request Timeout", 001),
          ),
        );
  }

  static Future<http.Response> updateUser(
      firstName, lastName, phoneNumber, longitude, latitude, dob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    return await http
        .put(
          Uri.parse('${AppUrl.baseUrl}users/update'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "phone_number": phoneNumber,
            "latitude": "23.0225",
            "longitude": "72.5714",
            "dob": dob
            // "dob": "2000-02-04T00:00:00.000+00:00"
          }),
        )
        .catchError(
          (e) => http.Response("$e", 001),
        )
        .timeout(
          Duration(seconds: Utils.timeoutSecondsApi),
          onTimeout: () => Future.value(
            http.Response("Request Timeout", 001),
          ),
        );
  }
}
