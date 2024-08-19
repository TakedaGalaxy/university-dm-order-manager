import 'package:frontend/utils/http/http_client.dart';
import 'package:frontend/utils/localStorage/storage_utility.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  Future<bool> canCancel() {
    return Future.value(true);
  }

  Future<bool> canEdit() {
    return Future.value(true);
  }

  Future getOrders() async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }
      final res = await MyHttpHelper.getAuthorized('order', token);
      print(res);
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
