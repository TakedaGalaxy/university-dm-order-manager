import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/controllers/onboarding_controller.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MyDeviceUtils.getAppBarHeight(),
      right: MySizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Pular')
      )
    );
  }
}