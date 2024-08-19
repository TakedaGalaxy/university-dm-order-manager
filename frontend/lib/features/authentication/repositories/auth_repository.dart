import 'dart:convert';

import 'package:frontend/features/authentication/screens/login.dart';
import 'package:frontend/utils/http/http_client.dart';
import 'package:frontend/utils/localStorage/storage_utility.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  Future<bool> isLoged() async {
    final tk = await MyLocalStorage().readData('@rs:progapp_tk');
    if (tk) return true;
    return false;
  }

  Future<String> getName() async {
    final name = await MyLocalStorage().readData('@rs:progapp_name');
    if (name) return name;
    return 'Usuário';
  }

  Future<void> logout() async {
    final tk = await MyLocalStorage().readData('@rs:progapp_tk');
    await MyHttpHelper.delete('auth', tk);
    await MyLocalStorage().clearAll();
    Get.to(() => const LoginScreen());
  }

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

    if (res['accessToken'] != null) {
      print(res['accessToken']);
      await MyLocalStorage().saveData('@rs:progapp_tk', res['accessToken']);
      await MyLocalStorage().saveData('@rs:progapp_name', res['accessToken']);
    }
  }

  Future<bool> isAdmin() async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await MyHttpHelper.getAuthorized('auth/account', token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['profileType'] == 'ADM';
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e){
      print('Error in isAdmin: $e');
      return false;
    }
  }

  Future<String> getProfile() async {
    try {
      final token = await MyLocalStorage().readData('@rs:progapp_tk');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await MyHttpHelper.getAuthorized('auth/account', token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['profileType']);
        return data['profileType'];
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e){
      print('Error in getProfile: $e');
      return 'USER';
    }
  }

}
