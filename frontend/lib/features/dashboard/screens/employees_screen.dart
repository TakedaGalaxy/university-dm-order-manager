import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import 'Forms/update_employee.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final UserController _userController = Get.put(UserController());
  late Future<List<Map<String, dynamic>>> _employeesFuture;

  @override
  void initState() {
    super.initState();
    print('Inicializando EmployeesScreen'); // Adicionar log para depuração
    _employeesFuture = _userController.getAllEmployees();
  }

  String getProfileTypeName(String profileTypeName) {
    switch (profileTypeName) {
      case 'ADM':
        return 'Administrador';
      case 'CHEF':
        return 'Chefe';
      case 'WAITER':
        return 'Garçom';
      default:
        return 'Desconhecido';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _employeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading employees'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          } else {
            final employees = snapshot.data!;
            print('Funcionários exibidos na tela: $employees'); // Adicionar log para depuração
            return ListView.separated(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text('Nome: ${employee['name']}'),
                  subtitle: Text('Função: ${getProfileTypeName(employee['profileTypeName'])}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateEmployeeForm(employee: employee),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFF141218),
              ),
            );
          }
        },
      ),
    );
  }
}