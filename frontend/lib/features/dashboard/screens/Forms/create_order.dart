import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/controllers/create_order_controller.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateOrderForm extends StatelessWidget {
  const CreateOrderForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateOrderController());

    return Form(
      key: controller.createOrderFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: controller.description,
              validator: (value) => MyValidator.validateDescriptionOrder(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right), 
                labelText: MyTexts.orderDescription
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),
            TextFormField(
              controller: controller.table,
              keyboardType: TextInputType.number,
              validator: (value) => MyValidator.validateTableOrder(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.location), 
                labelText: MyTexts.table
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.createOrder(), child: const Text(MyTexts.createOrder))
            ),
          ],
        ),
      )
    );
  }
}
