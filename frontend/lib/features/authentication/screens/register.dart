import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/screens/widgets/register_form.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(MySizes.defaultSpace),
              child: Column(
                children: [
                  Text(
                    MyTexts.registerTitle,
                    style: Theme.of(context).textTheme.headlineMedium
                  ),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  
                  const RegisterForm()
                ],
              )
            )
          )
        );
  }
}
