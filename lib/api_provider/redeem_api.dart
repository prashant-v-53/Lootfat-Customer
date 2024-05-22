import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../res/url.dart';
import '../utils/utils.dart';

class UserRedeemAPI {
  static Future<http.Response> createRedeemApi(qrCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    return await http
        .post(
          Uri.parse(
              '${AppUrl.baseUrl}users/redeem/create?offer=OFFER_59323a8f-e922-47ab-a05e-724a0cefb329'),
          headers: {
            'authorization': 'Bearer $token',
          },
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

  static Future<http.Response> userRedeemList(page, limit) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    print(token);
    return await http
        .get(
          Uri.parse(
              '${AppUrl.baseUrl}users/redeem/list?page=$page&limit=$limit'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
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
