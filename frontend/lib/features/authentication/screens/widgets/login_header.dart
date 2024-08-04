import 'package:flutter/material.dart';
import 'package:frontend/utils/constants/images_strings.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 100,
          image: AssetImage(
            dark ? MyImages.darkAppLogo : 
            MyImages.lightAppLogo
          )
        ),
        const SizedBox(height: MySizes.md),
        Text(MyTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: MySizes.sm),
        Text(MyTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}