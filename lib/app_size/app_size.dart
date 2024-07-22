import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:injectable/injectable.dart';

final appSizes = AppSizes();

class AppSizes {
  static late final double scale;

  double get pixelRatio => ui.PlatformDispatcher.instance.implicitView!.devicePixelRatio;

  Size get screen => ui.PlatformDispatcher.instance.implicitView!.physicalSize / pixelRatio;
  AppSizes() {
    final shortestSide = screen.shortestSide;
    if (shortestSide < 320) {
      // screenType = 'Extra-Small';
      scale = 0.9;
    } else if (shortestSide < 600) {
      // screenType = 'Small';
      scale = 0.98;
    } else if (shortestSide < 960) {
      // screenType = 'Medium';
      scale = 1;
    } else if (shortestSide < 1200) {
      // screenType = 'Large';
      scale = 1.05;
    } else {
      // screenType = 'Extra-Large';
      scale = 1.1;
    }

    debugPrint('screenSize=$screen, scale=$scale');
  }
  late final double tiny = 2 * scale;
  late final double xxs = 4 * scale;
  late final double xs = 8 * scale;
  late final double sm = 16 * scale;
  late final double md = 32 * scale;
  late final double lg = 48 * scale;
  late final double xl = 72 * scale;
  late final double xxl = 86.4 * scale;
  late final double extra = 103.68 * scale;
  late final double bodyPadding = 24 * scale;
}
