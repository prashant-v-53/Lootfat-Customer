import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/helper.dart';

import 'package:lootfat_user/view/widgets/expansion.dart';

import '../../api_provider-/offers_api.dart';
import '../../model/offer_details_model.dart';
import '../../utils/images.dart';
import '../../utils/utils.dart';
import '../widgets/app_loader.dart';
import 'edit_profile_screen.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String offerId;

  OfferDetailsScreen({
    super.key,
    required this.offerId,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  bool isLoading = true;
  bool isExpanded = true;
  bool isRestaurantName = true;
  bool isAdderss = true;
  bool isStartDate = true;
  bool isEndDate = true;
  MyOffersDetailsModel? offerDetails;
  String offerId = '649410735144cab91144bea8';
  String type = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });

    // setState(() {
    //   offerId = widget.offerId;
    //   type = widget.type;
    // });
    myOffersListApi();
  }

  myOffersListApi() {
    try {
      setState(() {
        isLoading = true;
      });
      MyOffersAPI.myOffersDetails(offerId).then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          setState(() {
            offerDetails = MyOffersDetailsModel.fromJson(res['data']);
            isLoading = false;
          });
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          isLoading = false;
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

  manageApiError(statusCode, data) {
    print(statusCode);
    print(data);
    if ([409, 403, 401, 400, 422].contains(statusCode)) {
      Utils.toastMessage(data);
    } else if (statusCode == 500) {
      Utils.toastMessage('500 Server not found!');
    } else {
      Utils.toastMessage('Something Went Wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: isLoading == true
          ? AppLoader()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    offerDetails!.offerImage,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 6, top: 10, bottom: 10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offerDetails!.title.capitalizeFirst(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.main),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'Redeem Coupon',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff8c93a3)),
                                      ),
                                      SizedBox(width: 5),
                                      SvgPicture.asset(
                                        SvgImages.person,
                                        height: 15,
                                        width: 15,
                                        color: AppColors.main,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        offerDetails!.redeemedCount.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.main),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                child: InkWell(
                                  onTap: () {
                                    _scan();
                                  },
                                  highlightColor:
                                      AppColors.white.withOpacity(0.4),
                                  splashColor:
                                      AppColors.appColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      SvgImages.qrcodescanner,
                                      height: 25,
                                      width: 25,
                                      color: AppColors.main,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              maxLines: 1,
                              textScaleFactor: 1,
                              text: TextSpan(
                                text: '₹',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${offerDetails!.offerPrice.toString()} ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: AppColors.appColor)),
                                  TextSpan(
                                      text:
                                          '/ ₹${offerDetails!.price.toString()}',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Color(0xff8c93a3))),
                                ],
                              ),
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.appColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  offerDetails!.offerType,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.main,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color:
                              isExpanded ? AppColors.appColor : AppColors.main,
                          child: InkWell(
                              onTap: () {
                                setState(() => isExpanded = !isExpanded);
                              },
                              borderRadius: BorderRadius.circular(100),
                              highlightColor: AppColors.white.withOpacity(0.4),
                              splashColor: AppColors.white.withOpacity(0.2),
                              child: Ink(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  ExpandedSection(
                    expand: isExpanded,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: Text(
                        offerDetails!.description,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                          height: 1.4,
                          color: Color(0xff627477),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Restaurant Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.main,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color: isRestaurantName
                              ? AppColors.appColor
                              : AppColors.main,
                          child: InkWell(
                              onTap: () {
                                setState(
                                    () => isRestaurantName = !isRestaurantName);
                              },
                              borderRadius: BorderRadius.circular(100),
                              highlightColor: AppColors.white.withOpacity(0.4),
                              splashColor: AppColors.white.withOpacity(0.2),
                              child: Ink(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  isRestaurantName
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  ExpandedSection(
                    expand: isRestaurantName,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: Text(
                        offerDetails!.shop.shopName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                          height: 1.4,
                          color: Color(0xff627477),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Restaurant Adderss',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.main,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color:
                              isAdderss ? AppColors.appColor : AppColors.main,
                          child: InkWell(
                              onTap: () {
                                setState(() => isAdderss = !isAdderss);
                              },
                              borderRadius: BorderRadius.circular(100),
                              highlightColor: AppColors.white.withOpacity(0.4),
                              splashColor: AppColors.white.withOpacity(0.2),
                              child: Ink(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  isAdderss
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  ExpandedSection(
                    expand: isAdderss,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        offerDetails!.shop.shopNumber +
                            ' ' +
                            offerDetails!.shop.landMark +
                            ' ' +
                            offerDetails!.shop.city +
                            ' ' +
                            offerDetails!.shop.country +
                            ' ' +
                            offerDetails!.shop.postalCode,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                          height: 1.6,
                          color: Color(0xff627477),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Start Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.main,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color:
                              isStartDate ? AppColors.appColor : AppColors.main,
                          child: InkWell(
                              onTap: () {
                                setState(() => isStartDate = !isStartDate);
                              },
                              borderRadius: BorderRadius.circular(100),
                              highlightColor: AppColors.white.withOpacity(0.4),
                              splashColor: AppColors.white.withOpacity(0.2),
                              child: Ink(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  isStartDate
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  ExpandedSection(
                    expand: isStartDate,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: Text(
                        Utils.convertDate(offerDetails!.startDate.toString(),
                                'dd MMM, yyyy') +
                            ' at ' +
                            offerDetails!.startTime.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                          height: 1.4,
                          color: Color(0xff627477),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.main,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color:
                              isEndDate ? AppColors.appColor : AppColors.main,
                          child: InkWell(
                              onTap: () {
                                setState(() => isEndDate = !isEndDate);
                              },
                              borderRadius: BorderRadius.circular(100),
                              highlightColor: AppColors.white.withOpacity(0.4),
                              splashColor: AppColors.white.withOpacity(0.2),
                              child: Ink(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  isEndDate
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  ExpandedSection(
                    expand: isEndDate,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: Text(
                        Utils.convertDate(offerDetails!.endDate.toString(),
                                'dd MMM, yyyy') +
                            ' at ' +
                            offerDetails!.endTime.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                          height: 1.4,
                          color: Color(0xff627477),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
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

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
