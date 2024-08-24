import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/controllers/create_order_controller.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateOrderController());
    controller.getOrders();

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const HomeHeader(),
          Padding(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Column(children: [
              const SizedBox(height: MySizes.spaceBtwItems),
              Obx(() => Column(
                    children: controller.orders.map((order) {
                      return OrderCard(
                          description: order['description'],
                          table: order['table'],
                          canceled: order['cancelled'] ?? false,
                          delivered: order['deliveredAt'],
                          completed: order['completedAt'],
                          beingMande: order['beingMandeAt'],
                          id: order['id']);
                    }).toList(),
                  )),
            ]),
          ),
        ],
      ),
    ));
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    this.description = 'Heineken Long neck',
    this.table = '01',
    this.canceled = false, 
    this.delivered, 
    this.completed, 
    this.beingMande,
    required this.id,
  });

  final int id;

  final String description;
  final String table;

  final bool canceled;
  final String? delivered;
  final String? completed;
  final String? beingMande;

  getSatus() {
    if (canceled) {
      return 'Cancelado';
    } else if(delivered != null) {
      return 'Pedido entregue';
    } else if (completed != null) {
      return 'Pedido concluído';
    } else if (beingMande != null) {
      return 'Pedido sendo feito';
    } else {
      return 'Pedido informado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateOrderController());
    controller.getPermissions();

    return Card(
        color: MyColors.white,
        child: Container(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  children: [
                    const Icon(Iconsax.location,
                        color: MyColors.darkGrey, size: MySizes.iconSm),
                    const SizedBox(width: MySizes.spaceBtwItems),
                    Text('Mesa $table',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(Iconsax.edit, size: 24)),
                    Obx(() => controller.p1.value && !canceled ? 
                      IconButton(
                            onPressed: () => controller.cancelOrder(id.toString()),
                            icon: const Icon(
                              Iconsax.trash,
                              size: 24,
                              color: MyColors.error,
                            )) :
                      Container()
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(getSatus(),
                        style: TextStyle(
                            color:
                                canceled ? MyColors.error : getSatus() != 'Pedido entregue' ? MyColors.primary : MyColors.success)),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => controller.p1.value && !canceled ? 
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.deliveredOrder(id.toString()), child: const Text(MyTexts.markAsDelivered))
                      ) :
                      Container()
                    ),
                    Obx(() => controller.p2.value && !canceled ? 
                      const SizedBox(height: MySizes.spaceBtwItems)
                      : Container()
                    ),
                    Obx(() => controller.p2.value && !canceled ? 
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.producingOrder(id.toString()), child: const Text(MyTexts.markAsProducing))
                      ) :
                      Container()
                    ),
                    Obx(() => controller.p2.value && !canceled ? 
                      const SizedBox(height: MySizes.spaceBtwItems)
                      : Container()
                    ),
                    Obx(() => controller.p2.value && !canceled? 
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.completeOrder(id.toString()), child: const Text(MyTexts.markAsComplete))
                      ) :
                      Container()
                    ),
                  ],
                ),
              ]),
        ));
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: MyCurvedEdges(),
          child: Container(
              color: MyColors.primary,
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                height: 50,
                child: Stack(children: [
                  Positioned(
                      top: -150,
                      right: -250,
                      child: MyCircularContainer(
                          backgroundColor:
                              MyColors.textWhite.withOpacity(0.1))),
                  Positioned(
                      top: 100,
                      right: -300,
                      child: MyCircularContainer(
                          backgroundColor:
                              MyColors.textWhite.withOpacity(0.1))),
                  // Column(
                  //   children: [
                  //     // appbar
                  //     // filtros
                  //   ],
                  // )
                ]),
              )),
        )
      ],
    );
  }
}

class MyCircularContainer extends StatelessWidget {
  const MyCircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.backgroundColor = MyColors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}

class MyCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
        thirdLastCurve.dx, thirdLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
