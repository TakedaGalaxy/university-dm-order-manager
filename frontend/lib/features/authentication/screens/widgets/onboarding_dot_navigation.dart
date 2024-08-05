import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/controllers/onboarding_controller.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/device/device_utility.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoradingDotNavigation extends StatelessWidget {
  const OnBoradingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = MyHelperFunctions.isDarkMode(context);

    return Positioned(
        bottom: MyDeviceUtils.getBottomNavigationBarHeight() + 25,
        left: MySizes.defaultSpace,
        child: SmoothPageIndicator(
            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            count: 3,
            effect: ExpandingDotsEffect(
                activeDotColor: dark ? MyColors.light : MyColors.dark,
                dotHeight: 6)));
  }
}
