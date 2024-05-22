import 'package:http/http.dart' as http;
import 'package:lootfat_user/res/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

class BannerApi {
  static Future<http.Response> getBannerApi(String bannerImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);

    return await http
        .get(
          Uri.parse('${AppUrl.baseUrl}users/sponsored-banner/list'),
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
}
