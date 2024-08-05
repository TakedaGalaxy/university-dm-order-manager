import 'package:flutter/material.dart';
import 'package:frontend/common/styles/spacing_styles.dart';
import 'package:frontend/features/dashboard/screens/widgets/logout_button.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Padding(
        padding: MySpacingStyle.paddingWithAppBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: MySizes.md),
            Text('Seja bem vindo de volta!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: MySizes.sm),
            Text(MyTexts.onBoardingSubTitle1,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      const LogoutButton()
    ]));
  }
}
