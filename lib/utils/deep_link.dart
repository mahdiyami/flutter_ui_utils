import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:logger/logger.dart';
import 'package:uni_links/uni_links.dart';

class DeepLink {
  // static final Logger _logger = Logger();

  /// private constructor
  DeepLink._();

  /// the one and only instance of this singleton
  static final instance = DeepLink._();

  bool _initialURILinkHandled = false;
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  Function(Uri)? _callback;
  set callBack(Function(Uri) value) => _callback = value;
  StreamSubscription? _streamSubscription;

  void init() {
    initURIHandler();
    incomingLinkHandler();
  }

  Future<void> initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          ("Initial URI received $initialURI");
          _initialURI = initialURI;
          _callback?.call(initialURI);
        } else {
          // _logger.d("Null Initial URI received");
        }
      } on PlatformException {
        // 5
        // _logger.d("Failed to receive initial uri");
      } on FormatException catch (err) {
        // // 6
        // if (!mounted) {
        //   return;
        // }
        // _logger.d('Malformed Initial URI received');
        _err = err;
        // setState(() => _err = err; );
      }
    }
  }

  void incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        // _logger.d('Received URI: $uri');
        _currentURI = uri;
        _err = null;
        _callback?.call(uri!);
      }, onError: (Object err) {
        // _logger.d('Error occurred: $err');
        _currentURI = null;
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
    }
  }

  void dispose() {
    // _logger.d('dispose');
    _streamSubscription?.cancel();
  }
}
