import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_user/model/banner_daat_model.dart';
import 'package:lootfat_user/view/dashboard/view_all_offers_screen.dart';

import '../../api_provider-/banner_api.dart';
import '../../api_provider-/offers_api.dart';
import '../../model/home_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int selectedIndex = 0;
  CarouselController carouselController = CarouselController();
  HomeModel? homeModel;
  BannersModel? bannerModel;

  String title = '';
  String price = '';
  String shop = '';
  String offerprice = '';
  String offerimage = '';
  bool loading = true;
  String description = '';
  String offerPercentage = "";
  String redeemedCount = "";
  String bannerImage = '';

  @override
  void initState() {
    getBannerApi();
    offerHomePageListApi();
    super.initState();
  }

  offerHomePageListApi() {
    setState(() => loading = true);
    try {
      MyOffersAPI.offerHomePageList(title, price, offerprice, offerimage, shop, description,
              redeemedCount, offerPercentage)
          .then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          HomeModel homeModelData = homeModelFromJson(response.body);
          setState(() {
            homeModel = homeModelData;
            loading = false;
          });
          Utils.toastMessage(homeModelData.message);
          setState(() => loading = false);
        } else if ([409, 403, 401, 400, 422].contains(response.statusCode)) {
          setState(() => loading = false);
          Utils.toastMessage(res['message']);
        } else if (response.statusCode == 500) {
          setState(() => loading = false);
          Utils.toastMessage('500 Server not found!');
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          setState(() => loading = false);
          Utils.toastMessage(response.body);
        }
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  getBannerApi() {
    setState(() => loading = true);
    try {
      BannerApi.getBannerApi(bannerImage).then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          BannersModel bannersModelData = bannersModelFromJson(response.body);
          Utils.toastMessage(bannersModelData.message);
          setState(() {
            bannerModel = bannersModelData;
          });
        } else if ([409, 403, 401, 400, 422].contains(response.statusCode)) {
          setState(() => loading = false);
          Utils.toastMessage(res['message']);
        } else if (response.statusCode == 500) {
          setState(() => loading = false);
          Utils.toastMessage('500 Server not found!');
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          setState(() => loading = false);
          Utils.toastMessage(response.body);
        }
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offers"),
        automaticallyImplyLeading: false,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: new AlwaysStoppedAnimation<Color>(AppColors.appColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      height: 170,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      pauseAutoPlayOnTouch: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                    items: List.generate(
                      bannerModel!.data.length,
                      (index) => Image.network(
                        bannerModel!.data[index].bannerImage,
                        height: Utils.height(context),
                        fit: BoxFit.fill,
                        width: Utils.width(context),
                        errorBuilder: (context, url, error) => Container(
                            color: AppColors.appColor.withOpacity(0.1),
                            child: Icon(Icons.error, color: Colors.black)),
                        loadingBuilder:
                            (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.appColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      int.parse(loadingProgress.expectedTotalBytes.toString())
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  if (homeModel!.data.nearBy.isNotEmpty)
                    TitleView(
                        title: "Near by Offers",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllOffersScreen(),
                            ),
                          );
                        }),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeModel!.data.nearBy.length,
                    padding: const EdgeInsets.all(4.0),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        item: homeModel!.data.nearBy[index],
                        onTap: () {},
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                    ),
                  ),
                  if (homeModel!.data.trending.isNotEmpty)
                    TitleView(
                        title: "Trending Offers",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllOffersScreen(),
                            ),
                          );
                        }),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeModel!.data.trending.length,
                    padding: const EdgeInsets.all(4.0),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        item: homeModel!.data.trending[index],
                        onTap: () {},
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                    ),
                  ),
                  if (homeModel!.data.newArrival.isNotEmpty)
                    TitleView(
                        title: "New Arrival Offers",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllOffersScreen(),
                            ),
                          );
                        }),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeModel!.data.newArrival.length,
                    padding: const EdgeInsets.all(4.0),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        item: homeModel!.data.newArrival[index],
                        onTap: () {},
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                    ),
                  ),
                  if (homeModel!.data.expireSoon.isNotEmpty)
                    TitleView(
                        title: "Expire Soon Offers",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllOffersScreen(),
                            ),
                          );
                        }),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeModel!.data.expireSoon.length,
                    padding: const EdgeInsets.all(4.0),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        item: homeModel!.data.expireSoon[index],
                        onTap: () {},
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                    ),
                  ),
                  if (homeModel!.data.limited.isNotEmpty)
                    TitleView(
                        title: "Limited Offers",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllOffersScreen(),
                            ),
                          );
                        }),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeModel!.data.limited.length,
                    padding: const EdgeInsets.all(4.0),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        item: homeModel!.data.limited[index],
                        onTap: () {},
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final HomeOfferModel item;
  final Function()? onTap;

  const ProductItem({
    Key? key,
    required this.item,
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Ink.image(
                image: NetworkImage(item.offerImage),
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
                    item.shop.shopName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.main),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.main),
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
                          fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: '${item.offerPrice}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.appColor)),
                        TextSpan(
                            text: '/ ₹${item.price}',
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
                    child: const Text("Buy One Get One",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff8c93a3))),
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
              onTap: onTap!,
              highlightColor: AppColors.white.withOpacity(0.4),
              splashColor: AppColors.appColor.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
