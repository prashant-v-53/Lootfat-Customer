import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:lootfat_user/utils/utils.dart';
import 'package:lootfat_user/view/auth/login_screen.dart';

class Introduction {
  final String title;
  final String subTitle;
  final String image;

  Introduction({
    required this.title,
    required this.subTitle,
    required this.image,
  });
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentCarouselIndex = 0;
  int selectedIndex = 0;
  CarouselController carouselController = CarouselController();

  onTap(index) {
    currentCarouselIndex = index;
  }

  List<Introduction> introductionList = [
    Introduction(
      title: "Welcome to the LootFat",
      subTitle: "Best Discount App for Food Lovers. Eat\nMore & Pay Less",
      image: AppImages.banner,
    ),
    Introduction(
      title: "Explore",
      subTitle:
          "Discover Restaurants or Coffee Shops of\nyour choice in your city",
      image: AppImages.banner,
    ),
    Introduction(
      title: "Dine-In",
      subTitle: "Visit your Favourite Restaurant & Display\nLootFat App",
      image: AppImages.banner,
    ),
    Introduction(
      title: "Save",
      subTitle: "Enjoy Delicious Food with Big Savings on\nBill.",
      image: AppImages.banner,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SafeArea(
              bottom: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "skip",
                              style: const TextStyle(
                                color: AppColors.appColor,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: AppColors.appColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: Utils.height(context),
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
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                introductionList[index].title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                introductionList[index].subTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              Center(
                                child: Image.asset(
                                    introductionList[index].image,
                                    width: Utils.width(context) * 0.65,
                                    height: Utils.width(context) * 0.65),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: selectedIndex == 0
                      ? null
                      : () {
                          carouselController.previousPage();
                        },
                  child: Text(
                    selectedIndex == 0 ? '' : 'BACK',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                Row(
                  children: List.generate(
                    3,
                    (index) => indicator(index, currentCarouselIndex),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedIndex == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    } else {
                      carouselController.nextPage();
                    }
                  },
                  child: Text(
                    'NEXT',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  indicator(
    int? index,
    int? value,
  ) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == selectedIndex
            ? AppColors.appColor
            : const Color(0xffD9DAEB),
      ),
    );
  }
}
