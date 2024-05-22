import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/helper.dart';
import 'package:lootfat_user/utils/images.dart';
import '../../api_provider-/redeem_api.dart';
import '../../model/user_redeem_List_model.dart';
import '../../utils/utils.dart';
import '../widgets/app_loader.dart';

class MyUsedOffersScreen extends StatefulWidget {
  const MyUsedOffersScreen({super.key});

  @override
  State<MyUsedOffersScreen> createState() => _MyUsedOffersScreenState();
}

class _MyUsedOffersScreenState extends State<MyUsedOffersScreen>
    with SingleTickerProviderStateMixin {
  List<UserRedeemListModel> userRedeemList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 4;
  int lastPage = 1;
  int firstPage = 1;

  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    userRedeemListApi();
    scrollController.addListener(() {
      userRedeemListScrollController();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  userRedeemListApi() {
    try {
      setState(() {
        userRedeemList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      UserRedeemAPI.userRedeemList(firstPage, numberOfPostsPerRequest)
          .then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          List<UserRedeemListModel> newUserRedeemList = [];
          res['data']['results'].forEach((json) {
            newUserRedeemList.add(
              UserRedeemListModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            userRedeemList = newUserRedeemList;
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

  void userRedeemListScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
        });

        if (firstPage < lastPage) {
          UserRedeemAPI.userRedeemList(firstPage + 1, numberOfPostsPerRequest)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              if (kDebugMode) {
                print(decoded['totalPages']);
              }

              decoded['data']['results'].forEach((json) {
                userRedeemList.add(
                  UserRedeemListModel.fromJson(
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
          title: Text("My Used Offers"),
        ),
        body: ListView.builder(
            itemCount: userRedeemList.length,
            controller: scrollController,
            padding: const EdgeInsets.all(4.0),
            itemBuilder: (context, index) {
              if (index == userRedeemList.length) {
                return Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 6, bottom: 10),
                        child: noMoreData
                            ? Container()
                            : buildProgressIndicator(isPerformingRequest)));
              } else {
                return MyUsedOfferItem(
                    data: userRedeemList,
                    lastName: lastName,
                    firstName: firstName,
                    itemNo: index,
                    onTap: () {});
              }
            }));
  }
}

class MyUsedOfferItem extends StatelessWidget {
  final int itemNo;
  final String firstName;
  final String lastName;
  final Function()? onTap;
  final List<UserRedeemListModel> data;

  const MyUsedOfferItem({
    Key? key,
    required this.itemNo,
    required this.data,
    required this.firstName,
    required this.lastName,
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
      margin: EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Ink(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 90,
                  height: 90,
                  child: Ink.image(
                    image: NetworkImage(data[itemNo].offerImage),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[itemNo].title.capitalizeFirst(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main),
                      ),
                      SizedBox(height: 4),
                      Text(
                        data[itemNo].shop.shopName.capitalizeFirst(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main.withOpacity(0.4)),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              maxLines: 1,
                              textScaleFactor: 1,
                              text: TextSpan(
                                text: '₹',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${data[itemNo].offerPrice.toString()} ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.appColor)),
                                  TextSpan(
                                      text:
                                          '/ ₹${data[itemNo].price.toString()}',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xff8c93a3))),
                                ],
                              ),
                            ),
                          ),
                          Text('Give Review',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(0xffFFB427))),
                        ],
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.appColor,
                        ),
                        child: Text(data[itemNo].offerType,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppColors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ]),
              Divider(
                thickness: 1,
                color: AppColors.appColor.withOpacity(0.2),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      Utils.convertDate(
                              data[itemNo].startDate.toString(), 'dd MMM') +
                          ' to ' +
                          Utils.convertDate(
                              data[itemNo].endDate.toString(), 'dd MMM yyyy'),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff8c93a3)),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Redeem Coupon',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8c93a3)),
                      ),
                      SizedBox(width: 6),
                      SvgPicture.asset(
                        SvgImages.person,
                        height: 14,
                        width: 14,
                        color: AppColors.main,
                      ),
                      SizedBox(width: 6),
                      Text(
                        data[itemNo].redeemCount.toString(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
