import 'package:flutter/material.dart';
import 'package:frontend/features/controllers/user_controller.dart';
import 'package:get/get.dart';

class CreateEmployeeForm extends StatefulWidget {
  const CreateEmployeeForm({super.key});

  @override
  State<CreateEmployeeForm> createState() => _CreateEmployeeFormState();
}

class _CreateEmployeeFormState extends State<CreateEmployeeForm> {
  final UserController userController = Get.put(UserController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _selectedRole;

  final List<Map<String, String>> roles = [
    {'display': 'Administrador', 'value': 'ADM'},
    {'display': 'Chefe', 'value': 'CHEF'},
    {'display': 'Garçom', 'value': 'WAITER'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Employee'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Cargo'),
              items: roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role['value'],
                  child: Text(role['display']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              value: _selectedRole,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedRole != null) {
                  userController.createEmployee(
                    nameController.text,
                    passwordController.text,
                    _selectedRole!,
                  );
                }
              },
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}