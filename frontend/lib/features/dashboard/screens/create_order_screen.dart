import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/screens/Forms/create_order.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';

import '../../../utils/helpers/helper_functions.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = MyHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: darkMode ? const IconThemeData(color: Colors.white) : null,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Column(
              children: [
                Text(
                  MyTexts.createOrder,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                const SizedBox(height: MySizes.spaceBtwSections),
                const CreateOrderForm()
              ],
            )
          )
        )
      );
  }
}
