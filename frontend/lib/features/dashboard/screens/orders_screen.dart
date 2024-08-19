import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/screens/create_order_screen.dart';
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
    return Scaffold(
        body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),
            Padding(
              padding: const EdgeInsets.all(MySizes.defaultSpace),
              child: Column(
                children: [
                  const SizedBox(height: MySizes.spaceBtwItems),
                  Card(
                    color: MyColors.white,
                    child: Container(
                      padding: const EdgeInsets.all(MySizes.defaultSpace),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedido',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: MySizes.spaceBtwItems),
                          Row(
                            children: [
                              const Icon(Iconsax.location, color: MyColors.darkGrey, size: MySizes.iconSm),
                              const SizedBox(width: MySizes.spaceBtwItems),
                              Text('Mesa 1', style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                          const SizedBox(height: MySizes.spaceBtwItems),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit, size: 24)),
                              IconButton(onPressed: () {}, icon: const Icon(Iconsax.close_circle, size: 24)),
                              IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit, size: 24)),
                            ],
                          ),
                        ]
                      ),
                    )
                  ),
                ]
              ),
            ),
        ],
      ),
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