import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/utils.dart';

import '../../utils/colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: Container(
        width: Utils.width(context) * 0.7,
        color: AppColors.appColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Utils.height(context) * 0.1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: Image.asset(
                    //     AppImage.image,
                    //     height: 60,
                    //     width: 60,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Williams Ranase",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            "williamranase51@gmail.com",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // tileWidget(
              //   icon: AppImage.filterIcon,
              //   title: "Filters",
              //   onTap: () {
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget tileWidget({
  //   required String icon,
  //   required String title,
  //   required Function() onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 15,
  //         vertical: 10,
  //       ),
  //       child: Row(
  //         children: [
  //           SvgPicture.asset(
  //             icon,
  //             color: AppColors.whiteColor,
  //           ),
  //           wSizedBox20,
  //           Expanded(
  //             child: Text(
  //               title,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: AppColors.whiteColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
