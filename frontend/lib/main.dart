import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/features/repositories/user_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();

  Get.put(AuthenticationRepository());
  Get.put(UserRepository());


  runApp(const MyApp());
}
