import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/repositories/auth_repository.dart';
import 'package:frontend/features/dashboard/controllers/create_order_controller.dart';
import 'package:frontend/features/dashboard/controllers/socket.dart';
import 'package:frontend/features/dashboard/screens/widgets/confirmation_dialog.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/text_strings.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';

class OrdersScreen extends StatefulWidget {
  final bool isOrderHistory;
  const OrdersScreen({super.key, this.isOrderHistory = false});

  @override
  State<OrdersScreen> createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  final controller = Get.put(CreateOrderController());
  final socket = Get.put(MySocketHelper());
  String selectedFilter = '';
  var filterCounts = {
    'Todos': 0.obs,
    'Informado': 0.obs,
    'Em produção': 0.obs,
    'Concluído': 0.obs,
    'Entregue': 0.obs,
    'Cancelado': 0.obs,
  }.obs;

  String userRole = '';

  @override
  void initState() {
    super.initState();
    init();
    socket.initialize();
    socket.onOrder((dynamic order) {
      //controller.updateOrder(order);
      //setState(() {});
      controller.getOrders().then((data) {
        updateFilterCounts();
        setState(() {});
      });
    });
  }

  Future<void> init() async {
    userRole = await AuthenticationRepository.instance.getProfile();
    print('User role in init: $userRole');
    setFilter(userRole);
    await controller.getOrders();
    updateFilterCounts();

    setState(() {});
  }

  void setFilter(String userRole) {
    print('User role: $userRole');

    if (userRole == 'ADM') {
      selectedFilter = 'Todos';
    } else if (userRole == 'CHEF') {
      selectedFilter = 'Informado';
    } else if (userRole == 'WAITER') {
      selectedFilter = 'Concluído';
    }
  }

  void updateFilterCounts() {
    filterCounts['Todos']!.value = getOrderCount('Todos');
    filterCounts['Informado']!.value = getOrderCount('Informado');
    filterCounts['Em produção']!.value = getOrderCount('Em produção');
    filterCounts['Concluído']!.value = getOrderCount('Concluído');
    filterCounts['Entregue']!.value = getOrderCount('Entregue');
    filterCounts['Cancelado']!.value = getOrderCount('Cancelado');

    print('Filter counts: $filterCounts');
  }

  List<Map<String, dynamic>> getFilteredOrders() {
    switch (selectedFilter) {
      case 'Informado':
        return controller.orders
            .where((order) =>
                order['beingMandeAt'] == null &&
                order['completedAt'] == null &&
                order['deliveredAt'] == null &&
                order['cancelled'] == false)
            .toList()
            .cast<Map<String, dynamic>>();
      case 'Em produção':
        return controller.orders
            .where((order) =>
                order['beingMandeAt'] != null &&
                order['completedAt'] == null &&
                order['deliveredAt'] == null &&
                order['cancelled'] == false)
            .toList()
            .cast<Map<String, dynamic>>();
      case 'Concluído':
        return controller.orders
            .where((order) =>
                order['completedAt'] != null &&
                order['deliveredAt'] == null &&
                order['cancelled'] == false)
            .toList()
            .cast<Map<String, dynamic>>();
      case 'Entregue':
        return controller.orders
            .where((order) =>
                order['deliveredAt'] != null && order['cancelled'] == false)
            .toList()
            .cast<Map<String, dynamic>>();
      case 'Cancelado':
        return controller.orders
            .where((order) => order['cancelled'] == true)
            .toList()
            .cast<Map<String, dynamic>>();
      default:
        return controller.orders.cast<Map<String, dynamic>>();
    }
  }

  int getOrderCount(String filter) {
    switch (filter) {
      case 'Informado':
        return controller.orders
            .where((order) =>
                order['beingMandeAt'] == null &&
                order['completedAt'] == null &&
                order['deliveredAt'] == null &&
                order['cancelled'] == false)
            .length;
      case 'Em produção':
        return controller.orders
            .where((order) =>
                order['beingMandeAt'] != null &&
                order['completedAt'] == null &&
                order['deliveredAt'] == null &&
                order['cancelled'] == false)
            .length;
      case 'Concluído':
        return controller.orders
            .where((order) =>
                order['completedAt'] != null &&
                order['deliveredAt'] == null &&
                order['cancelled'] == false)
            .length;
      case 'Entregue':
        return controller.orders
            .where((order) =>
                order['deliveredAt'] != null && order['cancelled'] == false)
            .length;
      case 'Cancelado':
        return controller.orders
            .where((order) => order['cancelled'] == true)
            .length;
      default:
        return controller.orders.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = MyHelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: widget.isOrderHistory
            ? AppBar(
                title: const Text('Histórico de pedidos'),
                leading: IconButton(
                  icon: Icon(
                    Iconsax.arrow_left,
                    color: darkMode ? MyColors.white : MyColors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeader(),
              Padding(
                padding: const EdgeInsets.all(MySizes.defaultSpace),
                child: Column(children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 4),
                        if (widget.isOrderHistory || userRole == 'ADM') ...[
                          Flexible(
                            fit: FlexFit.loose,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 80, maxWidth: 105),
                              child: Obx(
                                () => FilterButton(
                                  label: 'Todos',
                                  count: filterCounts['Todos']!,
                                  isSelected: selectedFilter == 'Todos',
                                  onTap: () =>
                                      setState(() => selectedFilter = 'Todos'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (widget.isOrderHistory ||
                            userRole == 'ADM' ||
                            userRole == 'CHEF') ...[
                          Flexible(
                            fit: FlexFit.loose,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 100, maxWidth: 120),
                              child: Obx(
                                () => FilterButton(
                                  label: 'Informado',
                                  count: filterCounts['Informado']!,
                                  isSelected: selectedFilter == 'Informado',
                                  onTap: () => setState(
                                      () => selectedFilter = 'Informado'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 100, maxWidth: 120),
                              child: Obx(
                                () => FilterButton(
                                  label: 'Em produção',
                                  count: filterCounts['Em produção']!,
                                  isSelected: selectedFilter == 'Em produção',
                                  onTap: () => setState(
                                      () => selectedFilter = 'Em produção'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (widget.isOrderHistory ||
                            userRole == 'ADM' ||
                            userRole == 'WAITER') ...[
                          Flexible(
                            fit: FlexFit.loose,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 100, maxWidth: 120),
                              child: Obx(
                                () => FilterButton(
                                  label: 'Concluído',
                                  count: filterCounts['Concluído']!,
                                  isSelected: selectedFilter == 'Concluído',
                                  onTap: () => setState(
                                      () => selectedFilter = 'Concluído'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 100, maxWidth: 120),
                              child: Obx(
                                () => FilterButton(
                                  label: 'Entregue',
                                  count: filterCounts['Entregue']!,
                                  isSelected: selectedFilter == 'Entregue',
                                  onTap: () => setState(
                                      () => selectedFilter = 'Entregue'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 100, maxWidth: 120),
                              child: Obx(
                                () => FilterButton(
                                  label: 'Cancelado',
                                  count: filterCounts['Cancelado']!,
                                  isSelected: selectedFilter == 'Cancelado',
                                  onTap: () => setState(
                                      () => selectedFilter = 'Cancelado'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  Obx(() => Column(
                        children: getFilteredOrders().map((order) {
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

class FilterButton extends StatefulWidget {
  const FilterButton({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final RxInt count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  void updateCount(int newCount) {
    setState(() {
      widget.count.value = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = MyHelperFunctions.isDarkMode(context);
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: darkMode
            ? widget.isSelected
                ? const Color(0xFF272d50)
                : MyColors.darkGrey
            : widget.isSelected
                ? MyColors.primary
                : MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(
          color: darkMode
              ? widget.isSelected
                  ? const Color(0xFF272d50)
                  : MyColors.darkGrey
              : MyColors.primary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 120),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(widget.label,
                  style: TextStyle(
                      color: darkMode
                          ? MyColors.white
                          : widget.isSelected
                              ? MyColors.white
                              : MyColors.black)),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 10,
                backgroundColor: darkMode
                    ? MyColors.white
                    : widget.isSelected
                        ? MyColors.white
                        : MyColors.black,
                child: Obx(() => Text(
                      widget.count.value.toString(),
                      style: TextStyle(
                          color: darkMode
                              ? MyColors.black
                              : widget.isSelected
                                  ? MyColors.black
                                  : MyColors.white,
                          fontSize: 12),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
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
    } else if (delivered != null) {
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
    } else if (delivered != null) {
      return MyColors.success;
    } else if (completed != null) {
      return MyColors.primary;
    } else if (beingMande != null) {
      return Colors.yellow;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = MyHelperFunctions.isDarkMode(context);
    final controller = Get.put(CreateOrderController());
    final buttonColor = darkMode ? const Color(0xFF342c5c) : MyColors.primary;
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
            child: Stack(children: [
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
                                color: canceled
                                    ? MyColors.error
                                    : getStatus() != 'Pedido entregue'
                                        ? MyColors.primary
                                        : MyColors.success)),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => controller.p1.value &&
                                !canceled &&
                                completed != null &&
                                delivered == null
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ConfirmationDialog(
                                            title: 'Confirmar entrega',
                                            content:
                                                'Deseja confirmar a entrega do pedido?',
                                            onConfirm: () => controller
                                                .deliveredOrder(id.toString()),
                                          ),
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      side: BorderSide.none,
                                    ),
                                    child: const Text(MyTexts.markAsDelivered)),
                              )
                            : Container()),
                        Obx(() => controller.p2.value && !canceled
                            ? const SizedBox(height: MySizes.spaceBtwItems)
                            : Container()),
                        Obx(() => controller.p2.value &&
                                !canceled &&
                                (beingMande == null &&
                                    completed == null &&
                                    delivered == null)
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationDialog(
                                      title: 'Confirmar produção',
                                      content:
                                          'Deseja confirmar a produção do pedido?',
                                      onConfirm: () => controller
                                          .producingOrder(id.toString()),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    side: BorderSide.none,
                                  ),
                                  child: const Text(MyTexts.markAsProducing),
                                ),
                              )
                            : Container()),
                        Obx(() => controller.p2.value && !canceled
                            ? const SizedBox(height: MySizes.spaceBtwItems)
                            : Container()),
                        Obx(() => controller.p2.value &&
                                !canceled &&
                                beingMande != null &&
                                completed == null &&
                                delivered == null
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationDialog(
                                      title: 'Confirmar conclusão',
                                      content:
                                          'Deseja confirmar a conclusão do pedido?',
                                      onConfirm: () => controller
                                          .completeOrder(id.toString()),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    side: BorderSide.none,
                                  ),
                                  child: const Text(MyTexts.markAsComplete),
                                ),
                              )
                            : Container()),
                      ],
                    ),
                  ]),
              Positioned(
                right: 0,
                top: 0,
                child: Obx(
                  () => controller.p1.value &&
                          !canceled &&
                          (getStatus() != 'Pedido entregue' &&
                              getStatus() != 'Pedido concluído')
                      ? IconButton(
                          onPressed: () => showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  title: 'Cancelar pedido',
                                  content: 'Deseja cancelar o pedido?',
                                  onConfirm: () =>
                                      controller.cancelOrder(id.toString()),
                                ),
                              ),
                          tooltip: 'Cancelar pedido',
                          icon: const Icon(
                            Iconsax.trash,
                            size: 24,
                            color: MyColors.error,
                          ))
                      : Container(),
                ),
              )
            ]),
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
