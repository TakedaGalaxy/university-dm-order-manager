import 'dart:async';

import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

import '../repositories/user_repository.dart';

class UserController extends GetxController{
  final _employeesStreamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get employeesStream => _employeesStreamController.stream;

  Future createEmployee (String userName, String userPassword, String profileTypeName) async {
    try{
      await UserRepository().createEmployee(userName, userPassword, profileTypeName);
      MyHelperFunctions.showSnackBar('Funcionário criado com sucesso', "Green");
      updateEmployeesStream();
    } catch(e){
      MyHelperFunctions.showSnackBar('Erro ao criar funcionário', "Red");
      print('Erro ao criar funcionário: $e');
    }

  }

  Future updateEmployee (int id, String userName, String userPassword, String profileTypeName) async {
    print('ID: $id, Username: $userName, Password: $userPassword, ProfileTypeName: $profileTypeName');
    try{
      await UserRepository().updateEmployee(id, userName, userPassword, profileTypeName);
      MyHelperFunctions.showSnackBar('Funcionário atualizado com sucesso', "Green");
      updateEmployeesStream();
    } catch(e){
      MyHelperFunctions.showSnackBar('Erro ao atualizar funcionário', "Red");
      print('Erro ao atualizar funcionário: $e');
    }
  }

  Future<dynamic> getEmployee(int id) async {
    try {
      final employee = await UserRepository().getEmployee(id);
      return employee;
    } catch (e) {
      MyHelperFunctions.showSnackBar('Erro ao buscar funcionário', "Red");
      print('Erro ao buscar funcionário: $e');
      return {};
    }
  }

  Future<dynamic> getLoggedEmployee() async {
    try {
      final employeeProfile = await UserRepository().getLoggedEmployee();
      return employeeProfile;
    } catch (e) {
      MyHelperFunctions.showSnackBar('Erro ao buscar perfil do funcionário', "Red");
      print('Erro ao buscar perfil do funcionário: $e');
      return {};
    }
  }


  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    try {
      final employees = await UserRepository().getAllEmployees();
      return employees;
    } catch (e) {
      MyHelperFunctions.showSnackBar('Erro ao buscar funcionários', "Red");
      print('Erro ao buscar funcionários: $e');
      return [];
    }
  }

  Future deleteEmployee(int id) async {
    try {
      await UserRepository().deleteEmployee(id);
      MyHelperFunctions.showSnackBar('Funcionário deletado com sucesso', "Green");
      updateEmployeesStream();
    } catch (e) {
      MyHelperFunctions.showSnackBar('Erro ao deletar funcionário', "Red");
      print('Erro ao deletar funcionário: $e');
    }
  }

  Future<void> updateEmployeesStream() async {
    try{
      final employeeProfile = await getLoggedEmployee();
      if(employeeProfile['profileType'] == 'ADM'){
        final employees = await UserRepository().getAllEmployees();
        _employeesStreamController.add(employees);
      }
    } catch (e){
      print('Erro ao buscar funcionários: $e');
      _employeesStreamController.addError(e);
    }
  }

  @override
  void onInit(){
    super.onInit();
    updateEmployeesStream();
  }

  @override
  void onClose(){
    _employeesStreamController.close();
    super.onClose();
  }

}