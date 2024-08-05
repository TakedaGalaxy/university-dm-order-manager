import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

import '../repositories/user_repository.dart';

class UserController extends GetxController{

  Future createEmployee (String userName, String userPassword, String profileTypeName) async {
    try{
      await UserRepository().createEmployee(userName, userPassword, profileTypeName);
      MyHelperFunctions.showSnackBar('Funcionário criado com sucesso', "Green");
    } catch(e){
      MyHelperFunctions.showSnackBar('Erro ao criar funcionário', "Red");
      print('Erro ao criar funcionário: $e');
    }

  }

  Future updateEmployee (int id, String userName, String userPassword, String profileTypeName) async {
    try{
      await UserRepository().updateEmployee(id, userName, userPassword, profileTypeName);
      MyHelperFunctions.showSnackBar('Funcionário atualizado com sucesso', "Green");
    } catch(e){
      MyHelperFunctions.showSnackBar('Erro ao atualizar funcionário', "Red");
      print('Erro ao atualizar funcionário: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    try {
      print('Buscando funcionários');
      final employees = await UserRepository().getAllEmployees();
      print('Funcionários buscados: $employees');
      return employees;
    } catch (e) {
      MyHelperFunctions.showSnackBar('Erro ao buscar funcionários', "Red");
      print('Erro ao buscar funcionários: $e');
      return [];
    }
  }
}