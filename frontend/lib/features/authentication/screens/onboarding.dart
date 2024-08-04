import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/controllers/onboarding_controller.dart';
import 'package:frontend/features/authentication/screens/widgets/onboarding_dot_navigation.dart';
import 'package:frontend/features/authentication/screens/widgets/onboarding_next_button.dart';
import 'package:frontend/features/authentication/screens/widgets/onboarding_page.dart';
import 'package:frontend/features/authentication/screens/widgets/onboarding_skip.dart';
import 'package:frontend/utils/constants/images_strings.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
        body: Stack(children: [
      PageView(
        controller: controller.pageController,
        onPageChanged: controller.updatePageIndicator,
        children: const [
          OnBoardingPage(
              image: MyImages.onBoardingImage1,
              title: MyTexts.onBoardingTitle1,
              subtitle: MyTexts.onBoardingSubTitle1),
          OnBoardingPage(
              image: MyImages.onBoardingImage1,
              title: MyTexts.onBoardingTitle2,
              subtitle: MyTexts.onBoardingSubTitle2),
          OnBoardingPage(
              image: MyImages.onBoardingImage1,
              title: MyTexts.onBoardingTitle3,
              subtitle: MyTexts.onBoardingSubTitle3),
        ],
      ),
      const OnBoardingSkip(),
      const OnBoradingDotNavigation(),
      const OnBoardingNextButton()
    ]));
  }
}
