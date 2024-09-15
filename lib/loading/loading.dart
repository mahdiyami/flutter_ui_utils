import 'package:flutter/material.dart';
import 'package:flutter_ui_utils/loading/assets.dart';

class LoadingWidgetBtn extends StatelessWidget {
  final Color color;

  const LoadingWidgetBtn({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center, child: loadingAssets.linnerLoading(color));
  }
}

class LoadingWidget extends StatelessWidget {
  ///[0-1]
  final double? value;
  final Color? color;
  const LoadingWidget({super.key, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    var colorUsed = color ?? Theme.of(context).colorScheme.primary;
    // var invert = colorUsed.withOpacity(0.5);

    return SizedBox(
      height: 40,
      // width: 40,
      child: (value == null)
          ? loadingAssets.mainLoading(colorUsed)
          : CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(Colors.white70),
              color: color,
            ),
    );
  }
}
