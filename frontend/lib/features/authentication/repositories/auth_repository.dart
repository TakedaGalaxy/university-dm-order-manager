import 'package:frontend/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  Future<void> signUp(
      String userName, String userPassword, String companyName) async {
    Map<String, dynamic> body = {
      'userName': userName,
      'userPassword': userPassword,
      'companyName': companyName
    };

    await MyHttpHelper.post('auth/sign-in', body);
  }

  Future<void> signIn(
      String userName, String userPassword, String companyName) async {
    Map<String, dynamic> body = {
      'userName': userName,
      'userPassword': userPassword,
      'companyName': companyName
    };

    final res = await MyHttpHelper.post('auth/', body);
    print(res);
  }
}
