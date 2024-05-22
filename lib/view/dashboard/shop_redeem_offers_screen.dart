import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/utils.dart';
import '../../api_provider-/offers_api.dart';
import '../../model/shop_redeem_offer_model.dart';
import '../../utils/images.dart';
import '../widgets/app_loader.dart';
import '../widgets/app_text_field.dart';

class ShopRedeemOffersScreen extends StatefulWidget {
  const ShopRedeemOffersScreen({super.key});

  @override
  State<ShopRedeemOffersScreen> createState() => _ShopRedeemOffersScreenState();
}

class _ShopRedeemOffersScreenState extends State<ShopRedeemOffersScreen>
    with SingleTickerProviderStateMixin {
  List<ShopRedeemOfferModel> shopRedeemOfferList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 4;
  int lastPage = 1;
  int firstPage = 1;

  String search = '';
  String shopId = 'SHOP_2a4ba075-f4d1-4d19-9bba-4df3f935fd19';

  @override
  void initState() {
    myShopOffersApi();
    scrollController.addListener(() {
      myShopOffersApiScrollController();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  myShopOffersApi() {
    try {
      setState(() {
        shopRedeemOfferList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      MyOffersAPI.myShopOfferList(
              firstPage, numberOfPostsPerRequest, search, shopId)
          .then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          List<ShopRedeemOfferModel> newShopRedeemOfferList = [];
          res['data']['results'].forEach((json) {
            newShopRedeemOfferList.add(
              ShopRedeemOfferModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            shopRedeemOfferList = newShopRedeemOfferList;
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

  void myShopOffersApiScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
        });

        if (firstPage < lastPage) {
          MyOffersAPI.myShopOfferList(
                  firstPage + 1, numberOfPostsPerRequest, search, shopId)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              if (kDebugMode) {
                print(decoded['totalPages']);
              }

              decoded['data']['results'].forEach((json) {
                shopRedeemOfferList.add(
                  ShopRedeemOfferModel.fromJson(
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
        title: Text(
          "Near by offer",
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: AppTextField(
                  hintText: "search...",
                  prefixIcon: SvgImages.search,
                  errorMessage: '',
                  onSubmitted: (val) {
                    setState(() {
                      search = val;
                    });
                    myShopOffersApi();
                  },
                  onChange: (val) {
                    setState(() {
                      search = val;
                    });
                  }),
            ),
            SizedBox(height: 15),
            TitleView(title: "Search by Offers", onTap: () {}),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: shopRedeemOfferList.length,
              padding: const EdgeInsets.all(4.0),
              itemBuilder: (context, index) {
                if (index == shopRedeemOfferList.length) {
                  return Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 6, bottom: 10),
                          child: noMoreData
                              ? Container()
                              : buildProgressIndicator(isPerformingRequest)));
                } else {
                  return ProductItem(
                      data: shopRedeemOfferList, itemNo: index, onTap: () {});
                }
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final int itemNo;

  final Function()? onTap;
  final List<ShopRedeemOfferModel> data;

  const ProductItem({
    Key? key,
    required this.itemNo,
    required this.data,
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
        onTap: () {},
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Ink(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Ink.image(
                image: NetworkImage(data[itemNo].offerImage),
                width: Utils.width(context),
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[itemNo].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.main),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Redeem Coupon',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8c93a3)),
                      ),
                      SizedBox(width: 5),
                      SvgPicture.asset(
                        SvgImages.person,
                        height: 13,
                        width: 13,
                        color: AppColors.main,
                      ),
                      SizedBox(width: 5),
                      Text(
                        data[itemNo].redeemedCount.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
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
                            text: '${data[itemNo].offerPrice.toString()} ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.appColor)),
                        TextSpan(
                            text: '/ ₹${data[itemNo].price.toString()}',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xff8c93a3))),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.appColor,
                        width: 0.4,
                      ),
                    ),
                    child: Text(data[itemNo].offerType,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xff8c93a3))),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ]),
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
      padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
      child: Text(
        title!,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.main,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
