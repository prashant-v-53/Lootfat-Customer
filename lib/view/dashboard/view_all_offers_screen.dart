import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/utils.dart';
import '../../api_provider-/offers_api.dart';
import '../../model/my_offers_type_model.dart';
import '../widgets/app_loader.dart';

class ViewAllOffersScreen extends StatefulWidget {
  const ViewAllOffersScreen({super.key});

  @override
  State<ViewAllOffersScreen> createState() => _ViewAllOffersScreenState();
}

class _ViewAllOffersScreenState extends State<ViewAllOffersScreen>
    with SingleTickerProviderStateMixin {
  // int isSelect = 1;
  // bool isExpanded = true;

  // double start = 1.0;
  // double end = 100.0;

  // String selectedTitle = '';
  // List filterList = [
  //   {
  //     'id': 1,
  //     'title': 'New arrival',
  //   },
  //   {
  //     'id': 2,
  //     'title': 'Near by',
  //   },
  //   {
  //     'id': 3,
  //     'title': 'Price: Low to high',
  //   },
  //   {
  //     'id': 4,
  //     'title': 'Price: High to Low',
  //   },
  //   {
  //     'id': 5,
  //     'title': 'Top rated',
  //   },
  // ];

  List<MyOffersTypeModel> myOffersTypeList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 4;
  int lastPage = 1;
  int firstPage = 1;

  String offerType = 'trending';

  @override
  void initState() {
    myOffersTypeApi();
    scrollController.addListener(() {
      myOffersTypeApiScrollController();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  myOffersTypeApi() {
    try {
      setState(() {
        myOffersTypeList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      MyOffersAPI.myOfferTypeList(firstPage, numberOfPostsPerRequest, offerType)
          .then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          List<MyOffersTypeModel> newMyOffersTypeList = [];
          res['data']['results'].forEach((json) {
            newMyOffersTypeList.add(
              MyOffersTypeModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            myOffersTypeList = newMyOffersTypeList;
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

  void myOffersTypeApiScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
        });

        if (firstPage < lastPage) {
          MyOffersAPI.myOfferTypeList(
                  firstPage + 1, numberOfPostsPerRequest, offerType)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              if (kDebugMode) {
                print(decoded['totalPages']);
              }

              decoded['data']['results'].forEach((json) {
                myOffersTypeList.add(
                  MyOffersTypeModel.fromJson(
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
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 10),
            //   child: AppTextField(
            //       hintText: "search...",
            //       prefixIcon: SvgImages.search,
            //       errorMessage: '',
            //       suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
            //         Container(
            //           padding: EdgeInsets.all(3),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(6),
            //           ),
            //           child: Material(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(6),
            //             child: InkWell(
            //               onTap: () => showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   context: context,
            //                   backgroundColor: Colors.white,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadiusDirectional.only(
            //                       topEnd: Radius.circular(25),
            //                       topStart: Radius.circular(25),
            //                     ),
            //                   ),
            //                   builder: (context) => buildSheetSortby(context)),
            //               highlightColor: AppColors.white.withOpacity(0.4),
            //               splashColor: AppColors.appColor.withOpacity(0.2),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8),
            //                 child: SvgPicture.asset(
            //                   SvgImages.shotby,
            //                   height: 15,
            //                   width: 15,
            //                   color: AppColors.appColor,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         Container(
            //           height: 22,
            //           width: 2,
            //           decoration: BoxDecoration(
            //             color: AppColors.main.withOpacity(0.1),
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(3),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(6),
            //           ),
            //           child: Material(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(6),
            //             child: InkWell(
            //               onTap: () => showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   context: context,
            //                   backgroundColor: Colors.white,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadiusDirectional.only(
            //                       topEnd: Radius.circular(25),
            //                       topStart: Radius.circular(25),
            //                     ),
            //                   ),
            //                   builder: (context) => buildSheetFilter(context)),
            //               highlightColor: AppColors.white.withOpacity(0.4),
            //               splashColor: AppColors.appColor.withOpacity(0.2),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(10),
            //                 child: SvgPicture.asset(
            //                   SvgImages.filter,
            //                   height: 15,
            //                   width: 15,
            //                   color: AppColors.appColor,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ]),
            //       contentPadding: 0,
            //       onChange: (val) {
            //         print(val);
            //       }),
            // ),
            // TitleView(title: "Search by Offers", onTap: () {}),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: myOffersTypeList.length,
              padding: const EdgeInsets.all(4.0),
              itemBuilder: (context, index) {
                if (index == myOffersTypeList.length) {
                  return Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 6, bottom: 10),
                          child: noMoreData
                              ? Container()
                              : buildProgressIndicator(isPerformingRequest)));
                } else {
                  return ProductItem(
                      data: myOffersTypeList, itemNo: index, onTap: () {});
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

  // Widget buildSheetSortby(context) {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Color(0xfff4f6fa),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 10),
  //         Text(
  //           'Sort by',
  //           style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w700,
  //               color: AppColors.main),
  //         ),
  //         SizedBox(height: 10),
  //         ...filterList
  //             .asMap()
  //             .map((index, value) {
  //               return MapEntry(
  //                   index,
  //                   InkWell(
  //                     onTap: () {
  //                       setState(() {
  //                         this.isSelect = int.parse(index.toString());
  //                       });
  //                     },
  //                     highlightColor: AppColors.white.withOpacity(0.4),
  //                     splashColor: AppColors.appColor.withOpacity(0.2),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(6.0),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: Text(
  //                               filterList[index]['title'].toString(),
  //                               style: TextStyle(
  //                                   fontSize: 13,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: AppColors.main),
  //                             ),
  //                           ),
  //                           Icon(
  //                             isSelect == index
  //                                 ? Icons.radio_button_checked
  //                                 : Icons.radio_button_off,
  //                             color: isSelect == index
  //                                 ? AppColors.appColor
  //                                 : AppColors.main,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ));
  //             })
  //             .values
  //             .toList(),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildSheetFilter(context) {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Color(0xfff4f6fa),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 10),
  //         Text(
  //           'Filter',
  //           style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w700,
  //               color: AppColors.main),
  //         ),
  //         SizedBox(height: 5),
  //         Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Column(
  //             children: [
  //               Material(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: InkWell(
  //                   onTap: () {
  //                     setState(() => this.isExpanded = !isExpanded);
  //                   },
  //                   borderRadius: BorderRadius.circular(10),
  //                   highlightColor: AppColors.white.withOpacity(0.4),
  //                   splashColor: AppColors.appColor.withOpacity(0.2),
  //                   child: Ink(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                             child: Text(
  //                           selectedTitle.isEmpty
  //                               ? 'Select Gender'
  //                               : selectedTitle,
  //                           style: TextStyle(
  //                               fontSize: 15,
  //                               fontWeight: FontWeight.w500,
  //                               color: AppColors.main),
  //                         )),
  //                         Icon(
  //                           Icons.keyboard_arrow_down_outlined,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               ExpandedSection(
  //                 expand: isExpanded,
  //                 child: Center(
  //                   child: AnimatedContainer(
  //                     duration: Duration(seconds: 1),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.only(
  //                         bottomLeft: Radius.circular(8),
  //                         bottomRight: Radius.circular(8),
  //                       ),
  //                     ),
  //                     child: SizedBox(
  //                       height: Utils.height(context) * 0.3,
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                           children: [
  //                             ...filterList
  //                                 .asMap()
  //                                 .map((index, value) {
  //                                   return MapEntry(
  //                                       index,
  //                                       Material(
  //                                         color: Colors.white,
  //                                         child: InkWell(
  //                                           onTap: () {
  //                                             setState(() {
  //                                               selectedTitle =
  //                                                   filterList[index]['title']
  //                                                       .toString();
  //                                             });
  //                                           },
  //                                           highlightColor: AppColors.white
  //                                               .withOpacity(0.4),
  //                                           splashColor: AppColors.appColor
  //                                               .withOpacity(0.2),
  //                                           child: Padding(
  //                                             padding:
  //                                                 const EdgeInsets.all(6.0),
  //                                             child: Row(
  //                                               children: [
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     filterList[index]['title']
  //                                                         .toString(),
  //                                                     maxLines: 1,
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight:
  //                                                             FontWeight.w500,
  //                                                         color:
  //                                                             AppColors.main),
  //                                                   ),
  //                                                 ),
  //                                                 Icon(
  //                                                   selectedTitle ==
  //                                                           filterList[index]
  //                                                               ['title']
  //                                                       ? Icons
  //                                                           .radio_button_checked
  //                                                       : Icons
  //                                                           .radio_button_off,
  //                                                   color: selectedTitle ==
  //                                                           filterList[index]
  //                                                               ['title']
  //                                                       ? AppColors.appColor
  //                                                       : AppColors.main,
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ));
  //                                 })
  //                                 .values
  //                                 .toList(),
  //                             SizedBox(height: 5),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 15),
  //         Text(
  //           'Kilometer range',
  //           style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w700,
  //               color: AppColors.main),
  //         ),
  //         SliderTheme(
  //           data: SliderTheme.of(context).copyWith(
  //             showValueIndicator: ShowValueIndicator.never,
  //             thumbColor: AppColors.appColor,
  //             trackHeight: 2,
  //             //   thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
  //             //   overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
  //             activeTrackColor: AppColors.appColor,
  //             overlayColor: AppColors.appColor.withOpacity(0.1),
  //             inactiveTrackColor: Colors.white,
  //           ),
  //           child: RangeSlider(
  //             values: RangeValues(start, end),
  //             labels: RangeLabels(start.toString(), end.toString()),
  //             onChanged: (value) {
  //               setState(() {
  //                 start = value.start;
  //                 end = value.end;
  //               });
  //             },
  //             min: 1,
  //             max: 100,
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               start.round().toString() + ' km',
  //               style: TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w500,
  //                   color: AppColors.main),
  //             ),
  //             Text(
  //               end.round().toString() + ' km',
  //               style: TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w500,
  //                   color: AppColors.main),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 10),
  //         ElevatedButton(
  //           onPressed: () {},
  //           child: const Center(
  //             child: Text(
  //               'Submit',
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class ProductItem extends StatelessWidget {
  final int itemNo;

  final Function()? onTap;
  final List<MyOffersTypeModel> data;

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
                    data[itemNo].shop.shopName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.main),
                  ),
                  SizedBox(height: 2),
                  Text(
                    data[itemNo].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.main),
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
