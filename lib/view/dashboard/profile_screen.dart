import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/utils.dart';
import 'package:lootfat_user/view/dashboard/reviews_list_screen.dart';
import 'package:lootfat_user/view/widgets/are_you_sure_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'my_used_offers_screen.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  bool isLoading = true;
  String phoneCode = "+91";
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String birthDate = '';

  @override
  void initState() {
    profileDataGet();
    super.initState();
  }

  profileDataGet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName').toString();
      lastName = prefs.getString('lastName').toString();
      phoneNumber = prefs.getString('phoneNumber').toString();
      birthDate = prefs.getString('dob').toString();
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(),
                  ),
                );
              },
              highlightColor: AppColors.white.withOpacity(0.4),
              splashColor: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(AppColors.appColor),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffF4F6FA),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Container(
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.main,
                                ),
                                child: Text(
                                  (firstName[0] + lastName[0]).toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white),
                                )),
                            SizedBox(height: 20),
                            Container(
                              width: Utils.width(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Text(
                                firstName,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.main),
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: Utils.width(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              color: Colors.white,
                              child: Text(
                                lastName,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.main),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                  color: Colors.white,
                                  child: Text(
                                    phoneCode,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.main),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 12),
                                    color: Colors.white,
                                    child: Text(
                                      phoneNumber,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      convertDate(birthDate.toString(), 'dd'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.main),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    color: Colors.white,
                                    child: Text(
                                      convertDate(birthDate.toString(), 'MM'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.main),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      convertDate(birthDate.toString(), 'yyyy'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.main),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Profile setting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // color: Color(0xff8d93a3)
                          color: AppColors.main.withOpacity(0.4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffF4F6FA),
                          ),
                          child: Column(children: [
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyUsedOffersScreen(),
                                    ),
                                  );
                                },
                                title: 'My used offers'),
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReviewListScreen(),
                                    ),
                                  );
                                },
                                title: 'Reviews'),
                            userInfoView(
                                onTap: () async {
                                  const url =
                                      'https://lootfat-terms-and-conditions.blogspot.com/2023/06/terms-conditions-for-lootfat-application.html';
                                  if (await canLaunchUrlString(url)) {
                                    await launchUrlString(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                title: 'Terms & Conditions'),
                            userInfoView(
                                onTap: () async {
                                  const url =
                                      'https://lootfat-privacy-policy.blogspot.com/2023/06/privacy-policy-for-lootfat-food.html';
                                  if (await canLaunchUrlString(url)) {
                                    await launchUrlString(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                title: 'Privacy & Security'),
                            userInfoView(
                                onTap: () {
                                  gmailView();
                                },
                                title: 'help & Support'),
                            userInfoView(
                                onTap: () {
                                  onMenuClicked(
                                    context: context,
                                    title: 'Logout?',
                                    description: 'Are you sure want to logout?',
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreen(),
                                        ),
                                        (e) => false,
                                      );
                                    },
                                  );
                                },
                                title: 'Logout'),
                          ])),
                      const SizedBox(height: 30),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  gmailView() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'lootfatoffers@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Assistance Needed with LootFat Offers Application',
      }),
    );
    launchUrl(emailLaunchUri);
  }

  userInfoView({required String title, required Function() onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.main),
                ),
              ),
              SizedBox(height: 5),
              Container(
                  padding: EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.main,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String convertDate(String date, type) {
    String convertedDate = '';
    try {
      DateTime dateTime = DateTime.parse(date.toString());
      var data = DateFormat(type).format(dateTime);
      convertedDate = data.toString();
      print(convertedDate);
    } catch (e) {
      convertedDate = '';
    }
    return convertedDate;
  }
}
