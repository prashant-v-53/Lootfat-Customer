import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:lootfat_user/utils/utils.dart';

import '../../api_provider-/notification_api.dart';
import '../../model/notification_model.dart';
import '../widgets/app_loader.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  List<NotificationModel> notificationList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 6;
  int lastPage = 1;
  int firstPage = 1;
  @override
  void initState() {
    super.initState();
    notificationListApi();
    scrollController.addListener(() {
      getNotificationListScrollController();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  notificationListApi() {
    try {
      setState(() {
        notificationList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      NotificationAPI.notificationList(firstPage, numberOfPostsPerRequest)
          .then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          List<NotificationModel> newNotificationList = [];
          res['data']['results'].forEach((json) {
            newNotificationList.add(
              NotificationModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            notificationList = newNotificationList;
            firstPage = res['data']['page'];
            lastPage = res['data']['totalPages'];
            isLoading = false;
          });
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          setState(() {
            isLoading = false;
          });
          Utils.toastMessage(response.body);
        } else {
          setState(() {
            isLoading = false;
          });
          manageApiError(response.statusCode, res['message']);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getNotificationListScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
          isLoading = false;
        });

        if (firstPage < lastPage) {
          NotificationAPI.notificationList(
                  firstPage + 1, numberOfPostsPerRequest)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              if (kDebugMode) {
                print(decoded['totalPages']);
              }

              decoded['data']['results'].forEach((json) {
                notificationList.add(
                  NotificationModel.fromJson(
                    json,
                    decoded['data']['page'],
                    decoded['data']['totalPages'],
                    decoded['data']['totalResults'],
                    decoded['data']['limit'],
                  ),
                );
              });
              setState(() {
                firstPage = decoded['data']['page'];
                lastPage = decoded['data']['totalPages'];
              });
            } else {
              setState(() {
                isLoading = false;
                noMoreData = false;
                isPerformingRequest = false;
              });
              var decoded = json.decode(response.body);
              manageApiError(response.statusCode, decoded);
            }
          });
        } else if (firstPage == lastPage) {
          setState(() {
            isPerformingRequest = false;
            noMoreData = true;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  manageApiError(statusCode, data) {
    print(statusCode);
    print(data);
    if ([409, 403, 404, 401, 400, 422].contains(statusCode)) {
      Utils.toastMessage(data);
    } else if (statusCode == 500) {
      Utils.toastMessage('500 Server not found!');
    } else {
      Utils.toastMessage('Something Went Wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemCount: notificationList.length,
        itemBuilder: (context, index) {
          if (index == notificationList.length) {
            return Center(
                child: Container(
                    margin: EdgeInsets.only(top: 6, bottom: 10),
                    child: noMoreData
                        ? Container()
                        : buildProgressIndicator(isPerformingRequest)));
          } else {
            var item = notificationList[index];
            return NotificationItem(
                title: item.title,
                date: Utils.convertDate(item.date.toString(), 'dd MMM yyyy'),
                time: Utils.convertTime(item.date.toString()),
                body: item.body,
                onTap: () {});
          }
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String date;
  final String time;
  final Function()? onTap;
  const NotificationItem({
    Key? key,
    required this.title,
    required this.body,
    required this.date,
    required this.time,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () {},
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ink.image(
                image: AssetImage(AppImages.banner),
                height: 130,
                width: Utils.width(context),
                fit: BoxFit.fill,
              ),
              SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.main,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xff8D93A3),
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Divider(
                thickness: 1,
                color: AppColors.appColor.withOpacity(0.2),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Color(0xff8D93A3),
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  RichText(
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    maxLines: 1,
                    textScaleFactor: 1,
                    text: TextSpan(
                      text: date,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff8D93A3),
                          fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' at ',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(text: time),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleView extends StatelessWidget {
  final String? title;
  final Function()? onTap;

  const TitleView({
    Key? key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            title!,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.main,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          InkWell(
              onTap: onTap,
              highlightColor: AppColors.white.withOpacity(0.4),
              splashColor: AppColors.appColor.withOpacity(0.2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Text(
                  "View All",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.orange,
                  ),
                ),
              )),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
