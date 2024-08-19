import 'dart:convert';

import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/utils/http/http_client.dart';
import 'package:frontend/utils/localStorage/storage_utility.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  Future<bool> canDeleteAndDeliveredAndCancelAndEditAndExclude() async {
    final res = await AuthenticationRepository().getProfileType();
    if (res == 'waiter') return true;
    if (res == 'ADM' || res == 'adm') return true;
    return false;
  }

  Future<bool> completeAndProducing() async {
    final res = await AuthenticationRepository().getProfileType();
    if (res == 'chef') return true;
    return false;
  }

  Future<void> cancelOrder(String id) async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }

      await MyHttpHelper.deleteAuthorized('order/$id', token);
    } catch (e) {
      print('Error in cancelOrder: $e');
    }
  }

  Future<void> deliveredOrder(String id) async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }

      await MyHttpHelper.putAuthorized('order/delivered/$id', token);
    } catch (e) {
      print('Error in deliveredOrder: $e');
    }
  }

  Future<void> producingOrder(String id) async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }

      await MyHttpHelper.putAuthorized('order/producing/$id', token);
    } catch (e) {
      print('Error in producingOrder: $e');
    }
  }

  Future<void> completeOrder(String id) async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }

      await MyHttpHelper.putAuthorized('order/complete/$id', token);
    } catch (e) {
      print('Error in completeOrder: $e');
    }
  }

  Future getOrders() async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }
      final res = await MyHttpHelper.getAllAuthorized('order', token);
      final data = json.decode(res.body);
      await MyLocalStorage().saveData('@rs:progapp_orders', data);

      final resLocal = await MyLocalStorage().readData('@rs:progapp_orders');

      if (resLocal == null) return [];

      print(resLocal);
      return resLocal;
    } catch (e) {
      print('Error in getOrders: $e');
    }
  }

  Future<void> createOrder(String description, String table) async {
    Map<String, dynamic> body = {
      'description': description,
      'table': table,
    };

    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }
      await MyHttpHelper.postAuthorized('order', body, token);
    } catch (e) {
      print('Error in createOrder: $e');
    }
  }
}
