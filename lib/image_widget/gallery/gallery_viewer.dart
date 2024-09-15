// https://github.com/dev-ltk/flutter_gallery_demo/blob/main/lib/customInteractiveViewer.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_utils/style/animation_time.dart';
import 'package:flutter_ui_utils/style/app_size.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'pageview_gallery.dart';

class GalleryViewer extends StatefulWidget {
  final Color? bgColor;
  final String title;

  const GalleryViewer({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    required this.title,
    this.bgColor,
  }) : super(key: key);

  final List<Widget> items;
  final int selectedIndex;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final PageController pageCtrl;
  late final CarouselController carouselCtrl;

  late int currentIndex;
  bool showIndex = true;
  // bool pagingEnabled = true;
  late final Debouncer debouncer;
  @override
  void initState() {
    debouncer = Debouncer(delay: AnimationTimes.slow);
    pageCtrl =
        PageController(keepPage: false, initialPage: widget.selectedIndex, viewportFraction: 1);
    carouselCtrl = CarouselController();
    pageCtrl.addListener(() {
      setState(() {
        showIndex = true;
      });
      debouncer(() {
        setState(() {
          showIndex = false;
        });
      });
    });
    if (widget.items.length == 1) {
      debouncer(() {
        setState(() {
          showIndex = false;
        });
      });
    }
    currentIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void dispose() {
    pageCtrl.dispose();
    debouncer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // (Vibrator) this.context.getSystemService(Context.VIBRATOR_SERVICE);
    double bottomSize = kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    var fraction = bottomSize / width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, currentIndex);
        return false; // Prevent the view from being popped immediately
      },
      child: SafeArea(
        child: GestureDetector(
          child: Scaffold(
            backgroundColor: widget.bgColor ?? Colors.white,
            // appBar: ,
            body: Padding(
              padding: EdgeInsets.only(bottom: appSizes.bodyPadding),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: bottomSize,
                      child: AppPageViewGallery(
                        onPageChanged: (int index) {
                          if (currentIndex != index) {
                            currentIndex = index;
                            carouselCtrl.jumpToPage(currentIndex);
                            setState(() {});
                          }
                        },
                        items: widget.items,
                        selectedIndex: widget.selectedIndex,
                        pageController: pageCtrl,
                      )),
                  if (widget.title.isNotEmpty)
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _SlidingAppBar(
                          visible: showIndex,
                          child: AppBar(
                            title: Text(widget.title),
                            centerTitle: true,
                          ),
                        )),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: kToolbarHeight,
                    child: AnimatedOpacity(
                      duration: AnimationTimes.slow,
                      opacity: showIndex ? 0.5 : 0,
                      child: Chip(
                        label: Text(
                          '${currentIndex + 1} / ${widget.items.length}',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    height: bottomSize,
                    child: CarouselSlider.builder(
                      carouselController: carouselCtrl,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index, realIndex) {
                        var theme = Theme.of(context);
                        return AspectRatio(
                          aspectRatio: 1,
                          child: AnimatedContainer(
                            duration: AnimationTimes.med,
                            margin: EdgeInsets.all(index == currentIndex ? 0 : 2),
                            padding: EdgeInsets.all(index == currentIndex ? 2 : 0),
                            decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: (theme.cardTheme.shape is RoundedRectangleBorder)
                                    ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                                    : BorderRadius.zero),
                            child: ClipRRect(
                              borderRadius: (theme.cardTheme.shape is RoundedRectangleBorder)
                                  ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                                  : BorderRadius.zero,
                              child: InkWell(
                                onTap: () {
                                  carouselCtrl.jumpToPage(index);
                                },
                                child: FittedBox(fit: BoxFit.cover, child: widget.items[index]),
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 1,
                        pageSnapping: true,

                        enableInfiniteScroll: false,
                        viewportFraction: fraction,
                        enlargeCenterPage: false,
                        enlargeFactor: 0.15,
                        // enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        initialPage: widget.selectedIndex,
                        scrollPhysics:
                            const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        onPageChanged: (index, _) {
                          HapticFeedback.mediumImpact();
                          if (index != currentIndex) {
                            currentIndex = index;
                            pageCtrl.jumpToPage(index);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomableWidget extends StatefulWidget {
  final Widget item;
  const _ZoomableWidget({Key? key, required this.item, this.onChangeScrollable}) : super(key: key);
  final void Function(bool)? onChangeScrollable;

  @override
  State<_ZoomableWidget> createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<_ZoomableWidget> {
  late final TransformationController zoomTransformationController;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    zoomTransformationController = TransformationController(Matrix4.identity()..scale(1.001));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // zoomTransformationController.value = Matrix4.identity()..scale(1.001);
      widget.onChangeScrollable?.call(false);
    });
  }

  @override
  void dispose() {
    zoomTransformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (zoomTransformationController.value != Matrix4.identity()) {
      zoomTransformationController.value = Matrix4.identity();
    } else if (_doubleTapDetails != null) {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      zoomTransformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: zoomTransformationController,
        maxScale: 6,
        minScale: 1,
        // constrained: true,
        // scaleEnabled: false,
        // alignment: Alignment.center,
        boundaryMargin: const EdgeInsets.all(0),
        onInteractionStart: (details) {
          var scale = zoomTransformationController.value.getMaxScaleOnAxis();
          bool pagingEnabled = scale <= 1.0;

          widget.onChangeScrollable?.call(details.pointerCount < 2 && pagingEnabled);
        },
        onInteractionEnd: (ScaleEndDetails details) {
          var scale = zoomTransformationController.value.getMaxScaleOnAxis();
          bool pagingEnabled = scale <= 1.0;

          widget.onChangeScrollable?.call(details.pointerCount < 2 && pagingEnabled);
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: widget.item,
        ),
      ),
    );
  }
}

class _SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SlidingAppBar({
    required this.child,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AnimationTimes.med,
      height: visible ? preferredSize.height : 0.0,
      child: child,
    );
  }
}
