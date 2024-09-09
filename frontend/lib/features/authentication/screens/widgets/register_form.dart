import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/controllers/register_controller.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Form(
      key: controller.registerFormKey, 
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
            const SizedBox(height: MySizes.spaceBtwInputFields),
            Obx(() => TextFormField(
              controller: controller.confirmPassword,
              validator: (value) {
                if (value != controller.userPassword.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
              obscureText: controller.hidePasswordConfirmation.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: 'Confirmar Senha',
                suffixIcon: IconButton(
                    onPressed: () =>
                    controller.hidePasswordConfirmation.value = !controller.hidePasswordConfirmation.value,
                    icon: Icon(
                        controller.hidePasswordConfirmation.value ? Iconsax.eye_slash : Iconsax.eye
                    )
                ),
              ),
            )),
            const SizedBox(height: MySizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.signUp(), child: const Text(MyTexts.createAccount))
            ),
            const SizedBox(height: 8),
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