import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../res/url.dart';
import '../utils/utils.dart';

class ReviewAPI {
  static Future<http.Response> createReviewApi(
      String offerId, description, int star) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    return await http
        .post(
          Uri.parse('${AppUrl.baseUrl}users/review/create/$offerId'),
          headers: {
            'authorization': 'Bearer $token',
            "Content-type": "application/json",
          },
          body: jsonEncode({"description": description, "star": star.toInt()}),
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

  static Future<http.Response> reviewList(page, limit) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    print(token);
    return await http
        .get(
          Uri.parse(
              '${AppUrl.baseUrl}users/review/review-list?page=$page&limit=$limit'),
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
