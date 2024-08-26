import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/device/device_utility.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);

    return Positioned(
      top: MyDeviceUtils.getAppBarHeight(),
      right: MySizes.defaultSpace,
      child: TextButton(
        onPressed: () => AuthenticationRepository().logout(),
        child: Text('Sair', style: TextStyle(color: dark ? Colors.white : Colors.white)),
      )
    );
  }
}