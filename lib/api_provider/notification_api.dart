import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../res/url.dart';
import '../utils/utils.dart';

class NotificationAPI {
  static Future<http.Response> notificationList(page, limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    return await http
        .get(
          Uri.parse('${AppUrl.baseUrl}notification?page=$page&limit=$limit'),
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
