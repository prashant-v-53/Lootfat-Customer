import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../res/url.dart';
import '../utils/utils.dart';

class MyOffersAPI {
  static Future<http.Response> offerHomePageList(String title, price, offerprice, offerimage, shop,
      description, offerpercentage, redeemedcount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);

    return await http
        .get(
          Uri.parse('${AppUrl.baseUrl}offer/home-page'),
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

  static Future<http.Response> offerSearchList(page, limit, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    print(token);
    return await http
        .get(
          Uri.parse('${AppUrl.baseUrl}offer/search?search=$search&page=$page&limit=$limit'),
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

  static Future<http.Response> myOfferTypeList(page, limit, type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    print(token);
    return await http
        .get(
          Uri.parse('${AppUrl.baseUrl}offer/?filter_type=$type&page=$page&limit=$limit'),
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

  static Future<http.Response> myShopOfferList(page, limit, search, shopId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    print(token);
    return await http
        .post(
          Uri.parse(
              '${AppUrl.baseUrl}users/redeem/create?page=$page&limit=$limit&search=$search&offer=$shopId'),
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

  static Future<http.Response> myOffersDetails(offerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    return await http
        .get(
          Uri.parse('${AppUrl.baseUrl}offer/details/$offerId'),
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
