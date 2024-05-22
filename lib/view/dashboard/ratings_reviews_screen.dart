import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/images.dart';
import '../../api_provider-/review_api.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';
import 'bottom_bar_screen.dart';

class RatingsReviewScreen extends StatefulWidget {
  const RatingsReviewScreen({super.key});

  @override
  State<RatingsReviewScreen> createState() => _RatingsReviewScreenState();
}

class _RatingsReviewScreenState extends State<RatingsReviewScreen>
    with SingleTickerProviderStateMixin {
  double selectRating = 0;
  TextEditingController description = TextEditingController(text: 'nice');
  String descriptionError = '';
  String ratingError = '';

  bool validation() {
    bool isValid = true;
    setState(() {
      descriptionError = '';
      ratingError = '';
    });
    if (description.text.isEmpty) {
      setState(() {
        descriptionError = "Please Enter Description";
      });
      isValid = false;
    }
    if (selectRating == 0 || selectRating == 0.0) {
      setState(() {
        ratingError = "Please Select a Rating";
      });
      isValid = false;
    }
    return isValid;
  }

  createReviewApi() {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      LoadingOverlay.of(context).show();
      ReviewAPI.createReviewApi('649410735144cab91144bea8', description.text,
              selectRating.toInt())
          .then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(res['message']);
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: false,
              isDismissible: false,
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(25),
                  topStart: Radius.circular(25),
                ),
              ),
              builder: (context) => buildSheet(context));
        } else if ([409, 403, 401, 404, 400, 422]
            .contains(response.statusCode)) {
          Utils.toastMessage(res['message']);
          LoadingOverlay.of(context).hide();
        } else if (response.statusCode == 500) {
          LoadingOverlay.of(context).hide();
          Utils.toastMessage('500 Server not found!');
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(response.body);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ratings & Reviews"),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            if (validation()) {
              createReviewApi();
            }
          },
          child: const Center(
            child: Text(
              'Submit',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ProductItem(),
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.main),
                        ),
                        SizedBox(height: 14),
                        RatingBar(
                          initialRating: selectRating,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 57.0,
                          ratingWidget: RatingWidget(
                            full: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xffFFB427).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.star,
                                color: Color(0xffFFB427),
                              ),
                            ),
                            half: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xffFFB427).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.star,
                                color: Color(0xffFFB427),
                              ),
                            ),
                            empty: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 0.5,
                                    color: Color(0xff1E2035).withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.star,
                                  color: Color(0xff1E2035).withOpacity(0.2)),
                            ),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            setState(() {
                              selectRating = rating;
                              ratingError = '';
                            });
                          },
                        ),
                        if (ratingError.isNotEmpty)
                          Padding(
                              padding: EdgeInsets.only(left: 5),
                              child:
                                  AppTextField.inputErrorMessage(ratingError)),
                        // SizedBox(height: 14),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Not satisfied',
                        //       style: TextStyle(
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w500,
                        //           color: Color(0xffa4aab5)),
                        //     ),
                        //     SizedBox(width: 16),
                        //     Text(
                        //       'Very satisfied',
                        //       style: TextStyle(
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w500,
                        //           color: Color(0xffa4aab5)),
                        //     ),
                        //   ],
                        // ),
                      ]),
                ),
              ),
              TextField(
                controller: description,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff9ea4b2),
                  ),
                  hintText: "Write here...",
                ),
              ),
              if (descriptionError.isNotEmpty)
                AppTextField.inputErrorMessage(descriptionError),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSheet(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Image.asset(
            AppImages.thankyou,
            height: 80,
            width: 80,
          ),
          SizedBox(height: 14),
          Text(
            'Thank You for Your\nReview',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.main),
          ),
          SizedBox(height: 14),
          Text(
            'Your review will help us to identify areas where we can improve, as well as things that we are doing well. We take all feedback seriously and are committed to using it to make our app the best that it can be.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                letterSpacing: 0.2,
                height: 1.4,
                color: Color(0xff8D93A3)),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BottomBarScreen(),
                ),
              );
            },
            child: const Center(
              child: Text(
                'Submit',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              AppImages.banner,
              height: 100,
              width: 100,
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
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         'Burgers',
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: TextStyle(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w600,
                  //             color: Color(0xff00AD1D)),
                  //       ),
                  //     ),
                  //     SizedBox(width: 6),
                  //     Container(
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  //       decoration: BoxDecoration(
                  //         color: AppColors.appColor,
                  //         borderRadius: BorderRadius.circular(4),
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             Icons.star,
                  //             size: 15,
                  //             color: Colors.white,
                  //           ),
                  //           SizedBox(width: 4),
                  //           Text(
                  //             '3.1',
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: AppColors.white),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 2),
                  Text(
                    'HR Food Zone',
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
                        '140',
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
                      children: const <TextSpan>[
                        TextSpan(
                            text: '360 ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.appColor)),
                        TextSpan(
                            text: '/ ₹400',
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '10% OFF',
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
    );
  }
}
