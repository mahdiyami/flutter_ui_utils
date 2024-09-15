import 'package:flutter/widgets.dart';
import 'package:weton_core_base/export_lib.dart';

BackBtnAssets backBtnAssets =
    sl<BackBtnAssets>(instanceName: const String.fromEnvironment("assetPrefix"));

abstract class BackBtnAssets {
  ///AppIcons.arrow_right_outline
  IconData get icBack;
  IconData get icClose;
}
