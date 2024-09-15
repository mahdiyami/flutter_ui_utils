import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../pinch_zoom.dart';
import 'custom_intractive_viewer.dart';



enum AppPageViewGalleryZoomType {
  unZoomByRelease,
  normal,
}

class AppPageViewGallery extends StatefulWidget {
  const AppPageViewGallery({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    required this.pageController,
    this.onPageChanged,
    this.zoomType = AppPageViewGalleryZoomType.normal,
  }) : super(key: key);
  final PageController pageController;
  final void Function(int)? onPageChanged;
  final List<Widget> items;
  final int selectedIndex;
  final AppPageViewGalleryZoomType zoomType;
  @override
  State<AppPageViewGallery> createState() => _AppPageViewGalleryState();
}

class _AppPageViewGalleryState extends State<AppPageViewGallery> {
  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;

  bool _isZoomedIn = false;
  // flag to block horizontal drag from PageView
  bool _isBlockHorizontalDrag = false;
  bool _isReachedLeftBoundary = false;
  bool _isReachedRightBoundary = false;

  int _pageNo = 0;
  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    // block horizontal drag from PageView if the drag is in the opposite direction after reached the boundaries
    if (_isZoomedIn) {
      if (_isReachedLeftBoundary &&
          widget.pageController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        setState(() {
          _isBlockHorizontalDrag = true;
        });
      }

      if (_isReachedRightBoundary &&
          widget.pageController.position.userScrollDirection ==
              ScrollDirection.forward) {
        setState(() {
          _isBlockHorizontalDrag = true;
        });
      }
    }

    return true;
  }

  void _onInteractionUpdate(var details) {
    // tap position in view's coordinate system
    double viewX = 0;

    if (details is ScaleUpdateDetails) {
      viewX = details.localFocalPoint.dx;
    } else if (details is DragUpdateDetails) {
      viewX = details.localPosition.dx;
    }

    // tap postion in image's coordinate system
    double imageX = 0;

    if (details is ScaleUpdateDetails) {
      imageX = _transformationController.toScene(details.localFocalPoint).dx;
    } else if (details is DragUpdateDetails) {
      imageX = _transformationController.toScene(details.localPosition).dx;
    }

    double scale = _transformationController.value.getMaxScaleOnAxis();
    double viewWidth = MediaQuery.of(context).size.width;

    // distances in x direction to boundaries in view's coordinate system
    double dxToLeftBoundary = imageX * scale - viewX;
    double dxToRightBoundary =
        (viewWidth - imageX) * scale - (viewWidth - viewX);

    if (dxToLeftBoundary < 0.1) {
      _isReachedLeftBoundary = true;
    } else if (dxToRightBoundary < 0.1) {
      _isReachedRightBoundary = true;
    } else {
      _isReachedLeftBoundary = false;
      _isReachedRightBoundary = false;
    }
  }

  void _onInteractionEnd(var details) {
    // using gesture to zoom out does not return an identity matrix but one close to it, therefore check the difference to the identity matrix
    _isZoomedIn =
        _transformationController.value.absoluteError(Matrix4.identity()) > 1e-9
            ? true
            : false;

    if (_isZoomedIn && !(_isReachedLeftBoundary || _isReachedRightBoundary)) {
      setState(() {
        _isBlockHorizontalDrag = true;
      });
    } else {
      setState(() {
        _isBlockHorizontalDrag = false;
      });
    }
  }

  void _onPageChanged(int pageNo) {
    // reset zoom
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      }

      setState(() {
        _pageNo = pageNo;
      });
    });

    setState(() {
      _isBlockHorizontalDrag = false;
    });
    widget.onPageChanged?.call(pageNo);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else if (_doubleTapDetails != null) {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: PageView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        allowImplicitScrolling: true,
        controller: widget.pageController,
        onPageChanged: _onPageChanged,
        children: widget.items
            .mapIndexed(
              (image, i) =>
                  widget.zoomType == AppPageViewGalleryZoomType.unZoomByRelease
                      ? PinchZoomReleaseUnzoomWidget(
                          maxScale: 5,
                          minScale: 0.5,
                          // onInteractionUpdate: _onInteractionUpdate,
                          // onInteractionEnd: _onInteractionEnd,
                          // isBlockHorizontalDrag: _isBlockHorizontalDrag,
                          child: image)
                      : CustomInteractiveViewer(
                          onDoubleTap: _handleDoubleTap,
                          onDoubleTapDown: _handleDoubleTapDown,
                          boundaryMargin: const EdgeInsets.all(0),
                          transformationController:
                              i == _pageNo ? _transformationController : null,
                          maxScale: 5,
                          minScale: 0.5,
                          onInteractionUpdate: _onInteractionUpdate,
                          onInteractionEnd: _onInteractionEnd,
                          isBlockHorizontalDrag: _isBlockHorizontalDrag,
                          child: image,
                        ),
            )
            .toList(),
      ),
    );
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
