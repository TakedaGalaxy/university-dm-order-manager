import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/screens/create_order_screen.dart';
import 'package:frontend/features/dashboard/screens/widgets/logout_button.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';

import '../../authentication/repositories/auth_repository.dart';
import 'Forms/create_employee.dart';
import 'orders_screen.dart';
import 'employees_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isAdmin = false;

  static List<Widget> _widgetOptions = <Widget>[
    OrdersScreen(),
    EmployeesScreen(),
  ];


  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      bool adminStatus = await AuthenticationRepository.instance.isAdmin();
      setState(() {
        isAdmin = adminStatus;
      });
    } catch(e){
      print('Error in adminStatus: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed(){
    if(_selectedIndex ==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
      );
    }
    else if(_selectedIndex ==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateEmployeeForm()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seja bem vindo de volta!',
              style: TextStyle(
                color: dark ? MyColors.white : MyColors.white,
                fontSize: MySizes.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: MySizes.sm),
            Text(
              MyTexts.onBoardingSubTitle1,
              style: TextStyle(
                color: dark ? MyColors.white : MyColors.white,
                fontSize: MySizes.fontSizeMd,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: dark ? MyColors.darkContainer : MyColors.primary,
        automaticallyImplyLeading: false,
        actions: const [
          LogoutButton(),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: isAdmin? FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ) : null,
      bottomNavigationBar: isAdmin? BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Funcionários',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ) : null,
    );
  }
}
