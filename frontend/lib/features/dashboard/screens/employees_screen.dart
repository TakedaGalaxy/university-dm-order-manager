import 'package:flutter/material.dart';
import 'package:frontend/features/controllers/user_controller.dart';
import 'package:frontend/features/dashboard/screens/Forms/update_employee.dart';
import 'package:get/get.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _userController.updateEmployeesStream();
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

  void _showDeleteConfirmationDialog(int employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você realmente deseja deletar este usuário?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                _userController.deleteEmployee(employeeId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _userController.employeesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading employees'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          } else {
            final employees = snapshot.data!;
            return ListView.separated(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text('Nome: ${employee['name']}'),
                  subtitle: Text('Função: ${getProfileTypeName(employee['profileTypeName'])}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 105, 102, 102)),
                          onPressed: () {
                            _showDeleteConfirmationDialog(employee['id']);
                          }
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color.fromARGB(255, 105, 102, 102)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateEmployeeForm(employee: employee),
                            ),
                          );
                        },
                      ),
                    ],
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