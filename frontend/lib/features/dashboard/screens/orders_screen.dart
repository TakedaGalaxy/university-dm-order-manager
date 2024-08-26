import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/controllers/create_order_controller.dart';
import 'package:frontend/features/dashboard/screens/widgets/confirmation_dialog.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';


import '../../../utils/helpers/helper_functions.dart';

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
                      return Column(
                        children: [
                          OrderCard(
                              description: order['description'],
                              table: order['table'],
                              canceled: order['cancelled'] ?? false,
                              delivered: order['deliveredAt'],
                              completed: order['completedAt'],
                              beingMande: order['beingMandeAt'],
                              id: order['id'],
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
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

  getStatus() {
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

  borderColor() {
    if (canceled) {
      return MyColors.error;
    } else if(delivered != null) {
      return MyColors.success;
    } else if (completed != null) {
      return MyColors.primary;
    } else if (beingMande != null) {
      return Colors.yellow;
    } else {
      return MyColors.error;
    }
  }


  @override
  Widget build(BuildContext context) {
    final darkMode = MyHelperFunctions.isDarkMode(context);
    final controller = Get.put(CreateOrderController());
    final buttonCollor = darkMode ? const Color(0xFF342c5c) : MyColors.primary;
    controller.getPermissions();

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      strokeWidth: 2,
      color: borderColor(),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: darkMode ? const Color(0xFF272d50) : MyColors.white,
          child: Container(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Stack(
              children:[
                Column(
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
                        Text(getStatus(),
                            style: TextStyle(
                                color:
                                    canceled ? MyColors.error : getStatus() != 'Pedido entregue' ? MyColors.primary : MyColors.success)),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => controller.p1.value && !canceled && completed != null && delivered == null ?
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationDialog(
                                      title: 'Confirmar entrega',
                                      content: 'Deseja confirmar a entrega do pedido?',
                                      onConfirm: () => controller.deliveredOrder(id.toString()),
                                    ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonCollor,
                                  side: BorderSide.none,
                                ),
                                child: const Text(MyTexts.markAsDelivered)
                            ),
                          ) :
                          Container()
                        ),
                        Obx(() => controller.p2.value && !canceled ?
                          const SizedBox(height: MySizes.spaceBtwItems)
                          : Container()
                        ),
                        Obx(() => controller.p2.value && !canceled && (beingMande ==null && completed == null && delivered == null)?
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationDialog(
                                      title: 'Confirmar produção',
                                      content: 'Deseja confirmar a produção do pedido?',
                                      onConfirm: () => controller.producingOrder(id.toString()),
                                    ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonCollor,
                                  side: BorderSide.none,
                                ),
                                child: const Text(MyTexts.markAsProducing),
                            ),
                          ) :
                          Container()
                        ),
                        Obx(() => controller.p2.value && !canceled ?
                          const SizedBox(height: MySizes.spaceBtwItems)
                          : Container()
                        ),
                        Obx(() => controller.p2.value && !canceled && beingMande != null && completed == null && delivered == null?
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationDialog(
                                      title: 'Confirmar conclusão',
                                      content: 'Deseja confirmar a conclusão do pedido?',
                                      onConfirm: () => controller.completeOrder(id.toString()),
                                    ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonCollor,
                                  side: BorderSide.none,
                                ),
                                child: const Text(MyTexts.markAsComplete),
                            ),
                          ) :
                          Container()
                        ),
                      ],
                    ),
                  ]
              ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Obx(() => controller.p1.value && !canceled  && (getStatus() != 'Pedido entregue' && getStatus() != 'Pedido concluído')  ?
                  IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                              title: 'Cancelar pedido',
                              content: 'Deseja cancelar o pedido?',
                              onConfirm: () => controller.cancelOrder(id.toString())),
                      ),
                      tooltip: 'Cancelar pedido',
                      icon: const Icon(
                        Iconsax.trash,
                        size: 24,
                        color: MyColors.error,
                      )) :
                  Container(),
                  ),
                )
              ]
            ),
          )),
    );
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
