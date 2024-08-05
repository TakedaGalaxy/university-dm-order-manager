import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  final hidePassword = true.obs;

  final localStorage = GetStorage();

  final userName = TextEditingController();
  final userPassword = TextEditingController();
  final companyName = TextEditingController();

  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  Future signUp() async {
    try {
      // Ideia: Verificar conexão com a internet
      if (!registerFormKey.currentState!.validate()) {
        return const SnackBar(content: Text(MyTexts.createAccountError));
      }

      // await AuthenticationRepository()
      //     .signUp(userName.text, userPassword.text, companyName.text);
      await AuthenticationRepository()
          .signIn(userName.text, userPassword.text, companyName.text);
    } catch (e) {
      print(e);
      MyHelperFunctions.showSnackBar(MyTexts.createAccountError);
    }
  }
}
