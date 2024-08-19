import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/features/dashboard/screens/dashboard_screen.dart';
import 'package:frontend/features/repositories/order_repository.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  final description = TextEditingController();
  final table = TextEditingController();

  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();

  Future redirect() async {
    final toGoDash = await AuthenticationRepository().isLoged();
    if (toGoDash) Get.to(() => const DashboardScreen());
  }

  Future createOrder() async {
    try {
      if (!createOrderFormKey.currentState!.validate()) {
        return const SnackBar(content: Text(MyTexts.createOrderError));
      }

      await OrderRepository().createOrder(description.text, table.text);
      await OrderRepository().getOrders();

      description.text = '';
      table.text = '';

      Get.to(() => const DashboardScreen());
    } catch (e) {
      MyHelperFunctions.showSnackBar(MyTexts.createOrderError, 'Red');
    }
  }
}
