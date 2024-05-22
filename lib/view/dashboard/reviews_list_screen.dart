import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/helper.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider-/review_api.dart';
import '../../model/review_list_model.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../widgets/app_loader.dart';
import '../widgets/star_rating.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen>
    with SingleTickerProviderStateMixin {
  List<ReviewModel> reviewList = [];
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
    profileDataGet();
    super.initState();
    reviewListApi();
    scrollController.addListener(() {
      getReviewListScrollController();
    });
  }

  profileDataGet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName').toString();
      lastName = prefs.getString('lastName').toString();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  reviewListApi() {
    try {
      setState(() {
        reviewList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      ReviewAPI.reviewList(firstPage, numberOfPostsPerRequest).then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          List<ReviewModel> newReviewList = [];
          res['data']['results'].forEach((json) {
            newReviewList.add(
              ReviewModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            reviewList = newReviewList;
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

  void getReviewListScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
        });

        if (firstPage < lastPage) {
          ReviewAPI.reviewList(firstPage + 1, numberOfPostsPerRequest)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              if (kDebugMode) {
                print(decoded['totalPages']);
              }

              decoded['data']['results'].forEach((json) {
                reviewList.add(
                  ReviewModel.fromJson(
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
        title: Text("Review"),
      ),
      body: ListView.builder(
          itemCount: reviewList.length,
          controller: scrollController,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index) {
            if (index == reviewList.length) {
              return Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 6, bottom: 10),
                      child: noMoreData
                          ? Container()
                          : buildProgressIndicator(isPerformingRequest)));
            } else {
              return RiviewItem(
                  data: reviewList,
                  lastName: lastName,
                  firstName: firstName,
                  itemNo: index,
                  onTap: () {});
            }
          }),
    );
  }
}

class RiviewItem extends StatelessWidget {
  final int itemNo;
  final String firstName;
  final String lastName;
  final Function()? onTap;
  final List<ReviewModel> data;

  const RiviewItem({
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xffF4F6FA),
              padding: EdgeInsets.all(10),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    data[itemNo].offer.offerImage,
                    height: 90,
                    width: 90,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[itemNo].offer.title.capitalizeFirst(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.main),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Redeem Coupon',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff8c93a3)),
                            ),
                            SizedBox(width: 6),
                            SvgPicture.asset(
                              SvgImages.person,
                              height: 13,
                              width: 13,
                              color: AppColors.main,
                            ),
                            SizedBox(width: 6),
                            Text(
                              data[itemNo].offer.redeemedCount.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        RichText(
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
                                      '${data[itemNo].offer.offerPrice.toString()} ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.appColor)),
                              TextSpan(
                                  text:
                                      '/ ₹${data[itemNo].offer.price.toString()}',
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xff8c93a3))),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.appColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            data[itemNo].offer.offerType,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: StarRating(
                    onRatingChanged: (val) {},
                    color: Colors.amber,
                    rating: data[itemNo].star.toDouble(),
                  ),
                ),
                RichText(
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  maxLines: 1,
                  textScaleFactor: 1,
                  text: TextSpan(
                    text: Utils.convertDate(
                        data[itemNo].createdAt.toString(), 'dd MMM yyyy'),
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff8D93A3),
                        fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' at ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                          text: Utils.convertTime(
                              data[itemNo].createdAt.toString())),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(data[itemNo].description,
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 0.3,
                  wordSpacing: 1,
                  height: 1.4,
                  color: AppColors.main,
                )),
          ],
        ),
      ),
    );
  }
}
