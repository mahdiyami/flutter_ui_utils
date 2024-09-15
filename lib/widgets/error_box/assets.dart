import 'package:flutter/widgets.dart';
import 'package:weton_core_base/export_lib.dart';

ErrorBoxAssets errorBoxAssets =
    sl<ErrorBoxAssets>(instanceName: const String.fromEnvironment("assetPrefix"));

abstract class ErrorBoxAssets {
  Widget get errorImage;
  IconData get iconButtonRefresh;
}
