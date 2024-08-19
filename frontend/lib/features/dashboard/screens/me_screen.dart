import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  final UserController _userController = Get.put(UserController());
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final userInfo = await _userController.getLoggedEmployee();
    setState(() {
      print('User Info: $userInfo');
      _userInfo = userInfo;
    });
  }

  final List<Map<String, String>> roles = [
    {'display': 'Administrador', 'value': 'ADM'},
    {'display': 'Chefe', 'value': 'CHEF'},
    {'display': 'Garçom', 'value': 'WAITER'},
  ];

  @override
  Widget build(BuildContext context) {
    String? profileDisplayName;
    String? companyDisplayName;
    String? displayName;

    if(_userInfo != null){
      final profileType = _userInfo!['profileType'];
      profileDisplayName = roles.firstWhere((role) => role['value'] == profileType)['display'];
      companyDisplayName = _userInfo!['companyName'];
      displayName = _userInfo!['userName'];
    }
    return Scaffold(
      body: _userInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $displayName', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Empresa: $companyDisplayName', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text('Cargo: $profileDisplayName', style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}