import 'package:flutter/material.dart';
import 'package:frontend/common/styles/spacing_styles.dart';
import 'package:frontend/features/authentication/screens/widgets/login_form.dart';
import 'package:frontend/features/authentication/screens/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: MySpacingStyle.paddingWithAppBarHeight,
                child: Column(
                  children: [
                    LoginHeader(),

                    LoginForm()
                  ],
                )
              )
            )
          );
  }
}
