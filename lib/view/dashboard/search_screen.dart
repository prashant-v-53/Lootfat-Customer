import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:lootfat_user/utils/utils.dart';
import '../../api_provider-/offers_api.dart';
import '../../model/offer_search_model.dart';
import '../../utils/colors.dart';
import '../widgets/app_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  String search = '';
  List<OfferSearchListModel> searchList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 4;
  int lastPage = 1;
  int firstPage = 1;

  @override
  void initState() {
    searchListApi();
    scrollController.addListener(() {
      searchListApiScrollController();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  searchListApi() {
    try {
      setState(() {
        searchList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      MyOffersAPI.offerSearchList(firstPage, numberOfPostsPerRequest, search).then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          print(res);
          List<OfferSearchListModel> newSearchList = [];
          res['data']['results'].forEach((json) {
            newSearchList.add(
              OfferSearchListModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            searchList = newSearchList;
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

  void searchListApiScrollController() async {
    try {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
        });

        if (firstPage < lastPage) {
          MyOffersAPI.offerSearchList(firstPage + 1, numberOfPostsPerRequest, search)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              if (kDebugMode) {
                print(decoded['totalPages']);
              }

              decoded['data']['results'].forEach((json) {
                searchList.add(
                  OfferSearchListModel.fromJson(
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
        title: Text("Search"),
        automaticallyImplyLeading: false,
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
                    searchListApi();
                  },
                  onChange: (val) {
                    setState(() {
                      search = val;
                    });
                  }),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchList.length,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) => SearchListItem(itemNo: index, onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

//   Widget buildSheetSortby(context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Color(0xfff4f6fa),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10),
//           Text(
//             'Sort by',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.main),
//           ),
//           SizedBox(height: 10),
//           ...filterList
//               .asMap()
//               .map((index, value) {
//                 return MapEntry(
//                     index,
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           this.isSelect = int.parse(index.toString());
//                         });
//                       },
//                       highlightColor: AppColors.white.withOpacity(0.4),
//                       splashColor: AppColors.appColor.withOpacity(0.2),
//                       child: Padding(
//                         padding: const EdgeInsets.all(6.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 filterList[index]['title'].toString(),
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.main),
//                               ),
//                             ),
//                             Icon(
//                               isSelect == index
//                                   ? Icons.radio_button_checked
//                                   : Icons.radio_button_off,
//                               color: isSelect == index
//                                   ? AppColors.appColor
//                                   : AppColors.main,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ));
//               })
//               .values
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Widget buildSheetFilter(context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Color(0xfff4f6fa),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10),
//           Text(
//             'Filter',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.main),
//           ),
//           SizedBox(height: 5),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Material(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() => this.isExpanded = !isExpanded);
//                     },
//                     borderRadius: BorderRadius.circular(10),
//                     highlightColor: AppColors.white.withOpacity(0.4),
//                     splashColor: AppColors.appColor.withOpacity(0.2),
//                     child: Ink(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: Text(
//                             selectedTitle.isEmpty
//                                 ? 'Select Gender'
//                                 : selectedTitle,
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.main),
//                           )),
//                           Icon(
//                             Icons.keyboard_arrow_down_outlined,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 ExpandedSection(
//                   expand: isExpanded,
//                   child: Center(
//                     child: AnimatedContainer(
//                       duration: Duration(seconds: 1),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(8),
//                           bottomRight: Radius.circular(8),
//                         ),
//                       ),
//                       child: SizedBox(
//                         height: Utils.height(context) * 0.3,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               ...filterList
//                                   .asMap()
//                                   .map((index, value) {
//                                     return MapEntry(
//                                         index,
//                                         Material(
//                                           color: Colors.white,
//                                           child: InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 selectedTitle =
//                                                     filterList[index]['title']
//                                                         .toString();
//                                               });
//                                             },
//                                             highlightColor: AppColors.white
//                                                 .withOpacity(0.4),
//                                             splashColor: AppColors.appColor
//                                                 .withOpacity(0.2),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(6.0),
//                                               child: Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: Text(
//                                                       filterList[index]['title']
//                                                           .toString(),
//                                                       maxLines: 1,
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color:
//                                                               AppColors.main),
//                                                     ),
//                                                   ),
//                                                   Icon(
//                                                     selectedTitle ==
//                                                             filterList[index]
//                                                                 ['title']
//                                                         ? Icons
//                                                             .radio_button_checked
//                                                         : Icons
//                                                             .radio_button_off,
//                                                     color: selectedTitle ==
//                                                             filterList[index]
//                                                                 ['title']
//                                                         ? AppColors.appColor
//                                                         : AppColors.main,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ));
//                                   })
//                                   .values
//                                   .toList(),
//                               SizedBox(height: 5),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 15),
//           Text(
//             'Kilometer range',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.main),
//           ),
//           SliderTheme(
//             data: SliderTheme.of(context).copyWith(
//               showValueIndicator: ShowValueIndicator.never,
//               thumbColor: AppColors.appColor,
//               trackHeight: 2,
//               //   thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
//               //   overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
//               activeTrackColor: AppColors.appColor,
//               overlayColor: AppColors.appColor.withOpacity(0.1),
//               inactiveTrackColor: Colors.white,
//             ),
//             child: RangeSlider(
//               values: RangeValues(start, end),
//               labels: RangeLabels(start.toString(), end.toString()),
//               onChanged: (value) {
//                 setState(() {
//                   start = value.start;
//                   end = value.end;
//                 });
//               },
//               min: 1,
//               max: 100,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 start.round().toString() + ' km',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.main),
//               ),
//               Text(
//                 end.round().toString() + ' km',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.main),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {},
//             child: const Center(
//               child: Text(
//                 'Submit',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProductItem extends StatelessWidget {
//   final int itemNo;
//   final Function()? onTap;

//   const ProductItem({
//     Key? key,
//     required this.itemNo,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       margin: EdgeInsets.all(4),
//       child: InkWell(
//         onTap: () {},
//         borderRadius: BorderRadius.circular(5),
//         highlightColor: AppColors.white.withOpacity(0.4),
//         splashColor: AppColors.appColor.withOpacity(0.2),
//         child: Ink(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Product Item $itemNo',
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.main),
//                   ),
//                   SizedBox(height: 2),
//                   Text("Buy One Get One",
//                       maxLines: 1,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: Color(0xff606a7e))),
//                 ],
//               ),
//             ),
//             RichText(
//               overflow: TextOverflow.clip,
//               softWrap: true,
//               maxLines: 1,
//               textScaleFactor: 1,
//               text: TextSpan(
//                 text: '₹',
//                 style: TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 12,
//                     color: Colors.black),
//                 children: const <TextSpan>[
//                   TextSpan(
//                       text: '360 ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                           color: AppColors.appColor)),
//                   TextSpan(
//                       text: '/ ₹400',
//                       style: TextStyle(
//                           decoration: TextDecoration.lineThrough,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                           color: Color(0xff8c93a3))),
//                 ],
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

class SearchListItem extends StatelessWidget {
  final int itemNo;
  final Function()? onTap;
  const SearchListItem({
    Key? key,
    required this.itemNo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(5),
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patel Fast Food ',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.main,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text('Yogi chowk',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff606a7e))),
                  ],
                ),
              ),
              Text('Restaurant',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Color(0xff606a7e))),
            ],
          ),
        ),
      ),
    );
  }
}
