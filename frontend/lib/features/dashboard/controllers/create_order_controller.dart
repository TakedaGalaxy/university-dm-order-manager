import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/features/dashboard/screens/dashboard_screen.dart';
import 'package:frontend/features/dashboard/screens/orders_screen.dart';
import 'package:frontend/features/repositories/order_repository.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  final description = TextEditingController();
  final table = TextEditingController();
  final orders = [].obs;
  final p1 = false.obs;
  final p2 = false.obs;


  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();


  Future getPermissions() async {
    p1.value = await canDeleteAndDeliveredAndCancelAndEditAndExclude();
    p2.value = await completeAndProducing();
  }

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
      await getOrders();

      description.text = '';
      table.text = '';

      Get.to(() => const DashboardScreen());
    } catch (e) {
      MyHelperFunctions.showSnackBar(MyTexts.createOrderError, 'Red');
    }
  }

  Future getOrders() async {
    orders.value = await OrderRepository().getOrders();
  }

  Future cancelOrder(String id) async {
    await OrderRepository().cancelOrder(id);
    await getOrders();
    updateOrdersCount();
  }

  Future deliveredOrder(String id) async {
    await OrderRepository().deliveredOrder(id);
    await getOrders();
  }

  Future producingOrder(String id) async {
    await OrderRepository().producingOrder(id);
    await getOrders();
    updateOrdersCount();
  }

  Future completeOrder(String id) async {
    await OrderRepository().completeOrder(id);
    await getOrders();
    updateOrdersCount();
  }

  Future canDeleteAndDeliveredAndCancelAndEditAndExclude() async {
    return await OrderRepository()
        .canDeleteAndDeliveredAndCancelAndEditAndExclude();
  }

  Future completeAndProducing() async {
    return await OrderRepository().completeAndProducing();
  }

  void updateOrdersCount(){
    OrdersScreenState().updateFilterCounts();
  }


}
