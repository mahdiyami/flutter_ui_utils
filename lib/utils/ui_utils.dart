import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get_utils/get_utils.dart';

class UiUtils {
  static String getCurrentPlatform() {
    String platform = '';
    if (kIsWeb) {
      platform = 'pwa';
    } else if (GetPlatform.isIOS) {
      platform = 'ios';
    } else if (Platform.isAndroid) {
      platform = 'android';
    }
    return platform;
  }
}
