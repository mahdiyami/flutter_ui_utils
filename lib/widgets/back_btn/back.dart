import 'package:flutter/material.dart';
import 'package:flutter_ui_utils/widgets/back_btn/assets.dart';
import 'package:get/get.dart';

class AppBackBtn extends StatelessWidget {
  final int? id;
  final VoidCallback? func;
  final IconData? iconData;
  final Color? color;
  final bool isClose;
  const AppBackBtn({super.key, this.id, this.func, this.iconData, this.color}) : isClose = false;

  const AppBackBtn.close({super.key, this.id, this.func, this.iconData, this.color})
      : isClose = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: func ??
          () {
            Get.global(id).currentState?.maybePop();
          },
      icon: Icon(
        iconData ?? (isClose ? backBtnAssets.icClose : backBtnAssets.icBack),
        color: color,
      ),
    );
  }
}
