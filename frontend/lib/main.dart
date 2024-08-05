import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();

  AuthenticationRepository();

  runApp(const MyApp());
}
