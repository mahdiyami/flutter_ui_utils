import 'package:flutter/material.dart';

class PinchZoomReleaseUnzoomWidget extends StatefulWidget {
  static const Duration defaultResetDuration = Duration(milliseconds: 200);

  const PinchZoomReleaseUnzoomWidget(
      {required this.child,
      this.zoomChild,
      this.resetDuration = defaultResetDuration,
      this.resetCurve = Curves.ease,
      this.boundaryMargin = const EdgeInsets.only(bottom: 0),
      this.clipBehavior = Clip.none,
      this.minScale = 0.8,
      this.maxScale = 8,
      this.useOverlay = true,
      this.maxOverlayOpacity = 0.5,
      this.overlayColor = Colors.black,
      this.fingersRequiredToPinch = 2,
      this.twoFingersOn,
      this.twoFingersOff,
      this.log = true,
      super.key})
      : assert(minScale > 0),
        assert(maxScale > 0),
        assert(maxScale >= minScale);

  final Widget child;

  final Widget? zoomChild;

  final Clip clipBehavior;

  final double maxScale;

  final double minScale;

  /// The duration of the reset animation
  final Duration resetDuration;

  /// The curve of the reset animation
  final Curve resetCurve;

  final EdgeInsets boundaryMargin;

  final bool useOverlay;

  /// The max opacity of the overlay when users zooms in
  final double maxOverlayOpacity;

  /// Overlay color
  final Color overlayColor;

  /// Fingers required to start a pinch,
  /// if it's zero or below zero no validation will be performed
  final int fingersRequiredToPinch;

  /// This function is super useful to block scroll and make the pinch to zoom easier
  final Function? twoFingersOn;

  /// Function to unblock scroll again
  final Function? twoFingersOff;

  /// Log what's happening
  final bool log;

  @override
  State<PinchZoomReleaseUnzoomWidget> createState() =>
      _PinchZoomReleaseUnzoomWidgetState();
}

class _PinchZoomReleaseUnzoomWidgetState
    extends State<PinchZoomReleaseUnzoomWidget> with TickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  OverlayEntry? entry;
  List<OverlayEntry> overlayEntries = [];
  double scale = 1;

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: widget.resetDuration,
    )
      ..addListener(
        () => controller.value = animation!.value,
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed && widget.useOverlay) {
            Future.delayed(
                const Duration(milliseconds: 100), () => removeOverlay());
          }
        },
      );

    return buildWidget(widget.child);
  }

  void resetAnimation() {
    animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity())
        .animate(CurvedAnimation(
            parent: animationController, curve: widget.resetCurve));
    animationController.forward(from: 0);
  }

  Widget buildWidget(Widget zoomableWidget) {
    return Builder(
      builder: (context) => Listener(
        onPointerDown: (event) {
          events.add(event.pointer);
          int pointers = events.length;
          log('added new pointer. Total: $pointers');

          if (pointers >= 2 && widget.twoFingersOn != null) {
            widget.twoFingersOn!.call();
          }
        },
        onPointerUp: (event) {
          events.clear();
          int pointers = events.length;
          log('removed pointer. Total: $pointers');

          if (pointers < 2 && widget.twoFingersOff != null) {
            widget.twoFingersOff!.call();
          }
        },
        child: InteractiveViewer(
          clipBehavior: widget.clipBehavior,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          transformationController: controller,
          onInteractionStart: (details) {
            if (widget.fingersRequiredToPinch > 0 &&
                details.pointerCount != widget.fingersRequiredToPinch) {
              log('avoided start with ${details.pointerCount} fingers');
              return;
            }
            if (widget.useOverlay) {
              showOverlay(context);
            }
          },
          onInteractionEnd: (details) {
            if (overlayEntries.isEmpty) {
              return;
            }

            resetAnimation();
          },
          onInteractionUpdate: (details) {
            if (entry == null) return;

            scale = details.scale;
            entry?.markNeedsBuild();
          },
          panEnabled: false,
          boundaryMargin: widget.boundaryMargin,
          child: zoomableWidget,
        ),
      ),
    );
  }

  final events = [];

  void showOverlay(BuildContext context) {
    log('Show overlay. Count before: ${overlayEntries.length}');
    OverlayState overlay = Overlay.of(context);
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    Offset? offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(builder: (context) {
      double opacity = ((scale - 1) / (widget.maxScale - 1))
          .clamp(0, widget.maxOverlayOpacity);

      return Material(
        color: Colors.green.withOpacity(0.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: opacity,
                child: Container(color: widget.overlayColor),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: SizedBox(
                width: renderBox.size.width,
                height: renderBox.size.height,
                child: buildWidget(widget.zoomChild ?? widget.child),
              ),
            ),
          ],
        ),
      );
    });
    overlay.insert(entry!);

    // We need to control all the overlays added to avoid problems in scrolling,
    overlayEntries.add(entry!);
  }

  void removeOverlay() {
    log('remove overlay. Count: ${overlayEntries.length}');
    for (OverlayEntry entry in overlayEntries) {
      entry.remove();
    }
    overlayEntries.clear();
    entry = null;
  }

  void log(String message) {
    if (widget.log) {
      // AppLogger.d(messag);
    }
  }
}
