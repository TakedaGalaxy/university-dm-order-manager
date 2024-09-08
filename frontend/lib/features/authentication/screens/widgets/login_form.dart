import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/controllers/login_controller.dart';
import 'package:frontend/features/authentication/screens/register.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: controller.userName,
              validator: (value) => MyValidator.validateUserName(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right), 
                labelText: MyTexts.username
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),
            TextFormField(
              controller: controller.companyName,
              validator: (value) => MyValidator.validateCompanyName(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.house), 
                labelText: MyTexts.company
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),
            Obx(() => TextFormField(
              controller: controller.userPassword,
              validator: (value) => MyValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check), 
                labelText: MyTexts.password,
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                ), 
              ),
            )),
            const SizedBox(height: MySizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.signIn(), child: const Text(MyTexts.signIn))
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => Get.to(() => const RegisterScreen()), child: const Text(MyTexts.createAccount))
            )
          ],
        ),
      )
    );
  }
}