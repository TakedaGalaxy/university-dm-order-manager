import 'package:flutter/material.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
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
    final darkMode = MyHelperFunctions.isDarkMode(context);
    final iconColor = darkMode ? Colors.white : Colors.black;

    String? profileDisplayName;
    String? companyDisplayName;
    String? displayName;
    String? userInitial;

    if (_userInfo != null) {
      final profileType = _userInfo!['profileType'];
      profileDisplayName =
          roles.firstWhere((role) => role['value'] == profileType)['display'];
      companyDisplayName = _userInfo!['companyName'];
      displayName = _userInfo!['userName'];
      userInitial = displayName != null ? displayName[0] : '';
    }
    return Scaffold(
      body: _userInfo == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            darkMode ? Colors.deepPurple : Colors.blueGrey,
                        child: Text(
                          userInitial ?? '',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final widthFactor =
                              constraints.maxWidth < 600 ? 0.9 : 0.4;
                          return FractionallySizedBox(
                            widthFactor: widthFactor,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 200,
                                maxWidth: 300,
                              ),
                              child: SizedBox(
                                height: 300,
                                child: Card(
                                  color: darkMode
                                      ? MyColors.black
                                      : MyColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 10,
                                  shadowColor: darkMode ? null : MyColors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: iconColor,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        'Nome: $displayName',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall
                                                            ?.copyWith(
                                                                fontSize: 30,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.business,
                                                    size: 30,
                                                    color: iconColor,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        'Empresa: $companyDisplayName',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                fontSize: 30,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.work,
                                                    size: 30,
                                                    color: iconColor,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        'Cargo: $profileDisplayName',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                fontSize: 30,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
