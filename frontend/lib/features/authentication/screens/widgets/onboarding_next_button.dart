import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/controllers/onboarding_controller.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/device/device_utility.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);

    return Positioned(
        right: MySizes.defaultSpace,
        bottom: MyDeviceUtils.getBottomNavigationBarHeight(),
        child: ElevatedButton(
            onPressed: () => OnBoardingController.instance.nextPage(),
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), backgroundColor: dark ? MyColors.primary : Colors.black),
            child: const Icon(Iconsax.arrow_right_3)));
  }
}
