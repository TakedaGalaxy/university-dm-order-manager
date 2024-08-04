import 'package:flutter/material.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right), 
                labelText: MyTexts.username
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.house), 
                labelText: MyTexts.company
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check), 
                labelText: MyTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash), 
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text(MyTexts.createAccount))
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => Get.back(), child: const Text(MyTexts.back))
            )
          ],
        ),
      )
    );
  }
}