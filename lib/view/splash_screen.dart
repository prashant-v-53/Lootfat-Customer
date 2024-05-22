import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:lootfat_user/view/dashboard/bottom_bar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("token is $token");
      storeDeviceInfo(token);
    });

    navigationBar();
    super.initState();
  }

  navigationBar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    if (token != null) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomBarScreen(),
          ),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WelcomeScreen(),
          ),
        );
      });
    }
  }

  void storeDeviceInfo(fcmToken) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      // unique ID on iOS

      prefs.setString('deviceID', iosDeviceInfo.identifierForVendor.toString());
      prefs.setString('deviceToken', fcmToken);
      prefs.setString('deviceType', 'ios');
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      // unique ID on Android
      prefs.setString('deviceID', androidDeviceInfo.id.toString());
      prefs.setString('deviceToken', fcmToken);
      prefs.setString('deviceType', 'android');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          SvgImages.logo,
        ),
      ),
    );
  }
}
