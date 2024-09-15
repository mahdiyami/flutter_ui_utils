import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:flutter_ui_utils/export_lib.dart';
import 'package:get/get.dart';

// enum EmptyBoxType {
//   orders,
//   cartPage,
//   list,
//   location,
//   ;
// }
//
// class EmptyBox extends StatelessWidget {
//   final EmptyBoxType type;
//
//   const EmptyBox({this.type = EmptyBoxType.list, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: Get.height / 3.5,
//
//           /// child: Lottie.asset('assets/empty_box.json'),
//         ),
//         if (type == EmptyBoxType.cartPage)
//           Text(
//             "سبد خرید شما خالی است",
//             style: Get.textTheme.titleLarge,
//           ),
//         if (type == EmptyBoxType.orders)
//           Text(
//             "سفارش فعالی در این بخش وجود ندارد",
//             style: Get.textTheme.titleLarge,
//           )
//       ],
//     );
//   }
// }
//
// class ErrorBox extends StatelessWidget {
//   final String? message;
//   final VoidCallback? onTap;
//
//   const ErrorBox({super.key, this.message, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: Get.height / 3.5,
//
//           /// child:
//           /// Lottie.asset('assets/connection_lost.json', fit: BoxFit.contain),
//         ),
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.only(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (message != null && message!.isNotEmpty)
//                   Text(
//                     message!,
//                     style: Get.textTheme.titleMedium,
//                   ),
//                 if (onTap != null)
//                   SizedBox(
//                     /// padding: EdgeInsets.symmetric(vertical: appSizes.sm),
//                     width: Get.width / 2,
//                     child: AppButton(
//                       key: key,
//                       onPressed: () async {
//                         onTap;
//                       },
//                       title: const Text('تلاش مجدد'),
//                       expand: true,
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore: must_be_immutable

class AppEmptyBox extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? image;
  final String? buttonTitle;
  final IconData? buttonIcon;
  final Future Function()? onPress;
  final double? aspectRatio;
  final TextStyle? decriptoinErrorBoxStyle;
  final TextStyle? decriptoinBoxStyle;
  final TextStyle? titleErrorBoxStyle;
  final TextStyle? titleBoxStyle;

  const AppEmptyBox({
    super.key,
    this.title,
    this.description,
    this.image,
    this.onPress,
    this.buttonTitle,
    this.buttonIcon,
    this.aspectRatio,
    this.decriptoinErrorBoxStyle,
    this.titleErrorBoxStyle,
    this.decriptoinBoxStyle,
    this.titleBoxStyle,
  });

  const AppEmptyBox.empty({
    this.buttonTitle,
    this.buttonIcon,
    this.onPress,
    super.key,
    required Widget this.image,
    required String this.title,
    required String this.description,
    this.aspectRatio,
    this.decriptoinErrorBoxStyle,
    this.titleErrorBoxStyle,
    this.decriptoinBoxStyle,
    this.titleBoxStyle,
  }) : assert(
            buttonTitle != null ? onPress != null : onPress == null, 'set buttonTitle or onPress');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: appSizes.xxl * 5,
            left: Random().nextDouble() * double.infinity,
            width: 100,
            child: C.assets.orderStatusAssets.imageCloud,
          ),
          Positioned(
            left: Random().nextDouble() * double.infinity / 2 - (appSizes.xxl * 2),
            top: appSizes.xxl * 8,
            width: 150,
            child: C.assets.orderStatusAssets.imageCloud,
          ),
          Positioned(
            top: 200,
            right: Random().nextDouble() * double.infinity / 2,
            width: 60,
            child: C.assets.orderStatusAssets.imageCloud,
          ),
          Positioned(
            right: Random().nextDouble() * 100,
            top: double.infinity * 0.618,
            width: 90,
            child: C.assets.orderStatusAssets.imageCloud,
          ),
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.none,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: AspectRatio(
                          aspectRatio: aspectRatio ?? 2.1,
                          child: SizedBox(child: image ?? C.assets.errorBoxAssets.errorImage),
                        ),
                      ),
                      if (title == null) ...{
                        Padding(
                          padding: EdgeInsets.only(top: appSizes.xxl),
                          child: Text(
                            'titleErrorBoxTr'.tr,
                            style: titleErrorBoxStyle ?? Get.textTheme.titleLarge,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: appSizes.xxl, horizontal: appSizes.xxl),
                          child: Text(
                            textAlign: TextAlign.center,
                            'descriptionErrorBoxTr'.tr,
                            style: decriptoinErrorBoxStyle?.copyWith(
                                    color: Get.theme.colorScheme.onBackground) ??
                                Get.textTheme.labelSmall?.copyWith(
                                    fontSize: 11, color: Get.theme.colorScheme.onBackground),
                          ),
                        ),
                      } else if (title!.isNotEmpty) ...{
                        Padding(
                          padding: EdgeInsets.only(top: appSizes.xxl),
                          child: Text(
                            title!,
                            style: titleBoxStyle ?? Get.textTheme.titleLarge,
                          ),
                        ),
                      },
                      if (description != null) ...{
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: appSizes.bodyPadding),
                          child: Text(
                            textAlign: TextAlign.center,
                            description!,
                            style: (decriptoinBoxStyle ?? Get.textTheme.labelLarge)
                                ?.copyWith(color: Get.theme.colorScheme.appOnBackground?.shade700),
                          ),
                        ),
                      },
                      if (onPress != null) ...{
                        if (buttonTitle == null) ...{
                          AppButton(
                            onPressed: onPress,
                            suffixIcon: Icon(
                              C.assets.errorBoxAssets.iconButtonRefresh,
                            ),
                            title: Padding(
                              padding: EdgeInsetsDirectional.only(start: appSizes.xs),
                              child: Text('lableButtonErrorBoxTr'.tr),
                            ),
                          ),
                        } else
                          AppButton(
                            onPressed: onPress,
                            suffixIcon: Icon(
                              buttonIcon,
                            ),
                            title: Text(
                              buttonTitle ?? '',
                              textAlign: TextAlign.center,
                            ),
                          ),
                      },
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
