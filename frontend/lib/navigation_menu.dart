import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/features/dashboard/screens/employees_screen.dart';
import 'package:frontend/features/dashboard/screens/orders_screen.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = MyHelperFunctions.isDarkMode(context);
    controller.checkAdminStatus();

    return Scaffold(
      bottomNavigationBar: Obx(() => NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) =>
                  controller.selectedIndex.value = index,
              backgroundColor: darkMode ? MyColors.black : MyColors.white,
              indicatorColor: darkMode
                  ? MyColors.white.withOpacity(0.1)
                  : MyColors.black.withOpacity(0.1),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Iconsax.task), label: 'Pedidos'),
                NavigationDestination(
                    icon: Icon(Iconsax.user_edit), label: 'Funcionários'),
              ])),
      body: Obx(() => controller.isAdmin.value ? 
        controller.adminScreens[controller.selectedIndex.value] : 
        controller.screens[controller.selectedIndex.value]
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  RxBool isAdmin = false.obs;

  Future<void> checkAdminStatus() async {
    try {
      bool adminStatus = await AuthenticationRepository.instance.isAdmin();
      isAdmin.value = adminStatus;
    } catch (e) {
      SnackBar(content: Text('Erro ao verificar status de administrador: $e'));
    }
  }

  final adminScreens = [
    const OrdersScreen(),
    const EmployeesScreen(),
  ];

  final screens = [
    const OrdersScreen(),
    Container()
  ];

  final adminDestinations = const [
    NavigationDestination(icon: Icon(Iconsax.task), label: 'Pedidos'),
    NavigationDestination(icon: Icon(Iconsax.user_edit), label: 'Funcionários'),
  ];

    final destinations = const [
    NavigationDestination(icon: Icon(Iconsax.task), label: 'Pedidos'),
  ];
}
