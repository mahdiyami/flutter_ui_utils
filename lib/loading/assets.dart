import 'package:flutter/material.dart';
import 'package:weton_core_base/dep_injection/get_it_instance.dart';

LoadingAssets loadingAssets = sl<LoadingAssets>();

abstract class LoadingAssets {
  Widget Function(Color) get linnerLoading;
  Widget Function(Color) get mainLoading;
}
