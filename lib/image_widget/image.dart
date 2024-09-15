import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ui_utils/image_widget/palette_generator.dart';
import 'package:flutter_ui_utils/image_widget/svg_cacher.dart';
import 'package:flutter_ui_utils/loading/loading.dart';
import 'package:weton_core_base/extension/ext.dart';

import 'gallery/gallery_viewer.dart';

class ImageWidget extends StatefulWidget {
  static const _empty =
      //'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96.48 91.27"><defs><style>.cls-1{fill:#eee;}.cls-2{fill:#bcbcbc;}.cls-3{fill:#f9f9f9;}</style></defs><title>empty-light_1</title><g id="Layer_2" data-name="Layer 2"><g id="Layer_1-2" data-name="Layer 1"><path class="cls-1" d="M81.18,75.38v1.35a6.78,6.78,0,0,1-6.79,6.78H22.27a6.81,6.81,0,0,1-6.81-6.81V75.59C11.62,77.17,9.39,79,9.39,81.05c0,5.64,17.55,10.22,39.19,10.22s39.18-4.58,39.18-10.22C87.76,79,85.34,77,81.18,75.38Z"/><path class="cls-2" d="M74.5,83.5H70.39V82h4Zm-6.63,0h-4V82h4Zm-6.56,0h-4V82h4Zm-6.56,0h-4V82h4Zm-6.56,0h-4V82h4Zm-6.56,0h-4V82h4Zm-6.56,0H31V82h4Zm-6.56,0h-4V82h4Zm-6.59,0a6.74,6.74,0,0,1-4.14-1.65l1-1.13A5.34,5.34,0,0,0,22,82Zm55.34-.61-.63-1.36a5.29,5.29,0,0,0,2.49-2.41l1.34.68A6.8,6.8,0,0,1,77.26,82.88ZM16.08,79.59a6.76,6.76,0,0,1-.62-2.84V75.32H17v1.43A5.23,5.23,0,0,0,17.44,79Zm65.09-2.53L79.67,77a1.93,1.93,0,0,0,0-.24V73h1.5v3.76C81.18,76.85,81.18,77,81.17,77.06ZM17,72.8h-1.5v-4H17Zm64.22-2.34h-1.5v-4h1.5ZM17,66.24h-1.5v-4H17Zm64.22-2.33h-1.5v-4h1.5ZM17,59.68h-1.5v-4H17Zm64.22-2.34h-1.5v-4h1.5ZM17,53.12h-1.5v-4H17Zm64.22-2.34h-1.5v-4h1.5ZM17,46.56h-1.5v-4H17Zm64.22-2.34h-1.5v-4h1.5ZM17,40h-1.5V36H17Zm64.22-2.34h-1.5v-4h1.5ZM17,33.44h-1.5v-4H17ZM81.18,31.1h-1.5v-4h1.5ZM17,26.88h-1.5v-4H17Zm64.22-2.34h-1.5v-4h1.5ZM17,20.32h-1.5v-4H17ZM81.18,18h-1.5V14h1.5ZM17,13.76h-1.5v-4H17Zm64.22-2.34h-1.5v-4h1.5ZM17,7.2h-1.5V6.75A6.68,6.68,0,0,1,16.63,3l1.24.84a5.22,5.22,0,0,0-.91,3ZM79.42,5.13a5.21,5.21,0,0,0-2.1-2.76l.83-1.25a6.79,6.79,0,0,1,2.7,3.54Zm-60-2.85L18.66,1a6.82,6.82,0,0,1,3.55-1h.72V1.5h-.72A5.26,5.26,0,0,0,19.45,2.28Zm55.84-.71a5.07,5.07,0,0,0-.86-.07H71.37V0h3.06a6.71,6.71,0,0,1,1.1.09ZM68.85,1.5h-4V0h4Zm-6.56,0h-4V0h4Zm-6.56,0h-4V0h4Zm-6.56,0h-4V0h4Zm-6.56,0h-4V0h4Zm-6.56,0H32V0h4Zm-6.56,0h-4V0h4Z"/><path class="cls-1" d="M45.23,45.73,40.85,24.55A7.75,7.75,0,0,1,48.43,15h0A7.82,7.82,0,0,1,53,16.43a8,8,0,0,1,3,8.17L51.56,45.74C50.67,49.08,45.83,48.53,45.23,45.73Z"/><path class="cls-3" d="M42.54,17.62a7.88,7.88,0,0,0-2,5.28l4.73,22.83A3.28,3.28,0,0,0,49,48a3.24,3.24,0,0,0,.24-1.16l-.63-23.32A7.94,7.94,0,0,0,42.54,17.62Z"/><path class="cls-2" d="M48.48,48.79h-.11a3.91,3.91,0,0,1-3.87-2.91h0L40.11,24.7a8.51,8.51,0,0,1,8.32-10.48,8.55,8.55,0,0,1,5,1.6,8.66,8.66,0,0,1,3.3,8.93L52.3,45.89A3.82,3.82,0,0,1,48.48,48.79ZM46,45.57a2.45,2.45,0,0,0,2.44,1.72,2.34,2.34,0,0,0,2.44-1.75l4.42-21.1a7.19,7.19,0,0,0-2.7-7.4,7.28,7.28,0,0,0-8.75.38,7.17,7.17,0,0,0-2.23,7Z"/><circle class="cls-1" cx="48.47" cy="61.88" r="5.65"/><rect class="cls-2" x="81.92" y="12.09" width="1.5" height="2" transform="translate(47.94 89.25) rotate(-74.48)"/><path class="cls-2" d="M83.46,68.88,82,68.48l1.07-3.85,1.45.4Zm1.75-6.26-1.45-.4,1.08-3.85,1.44.4ZM87,56.36,85.51,56l1.07-3.85,1.45.4Zm1.74-6.25-1.45-.4,1.08-3.86,1.44.41Zm1.75-6.26L89,43.45l1.07-3.85,1.45.4Zm1.74-6.26-1.44-.4,1.07-3.85,1.44.4Zm1.75-6.26-1.45-.4,1.07-3.85,1.45.4Zm1.74-6.25-1.44-.41.55-2A5.21,5.21,0,0,0,95,21.28V21l1.49-.07c0,.11,0,.22,0,.33a6.68,6.68,0,0,1-.25,1.83Zm-1.26-6.16A5.32,5.32,0,0,0,92,16.52l.64-1.35a6.79,6.79,0,0,1,3.17,3.07Zm-4.73-3.1-3.85-1.07.4-1.44,3.85,1.07Z"/><rect class="cls-2" x="80.8" y="71.31" width="2" height="1.5" transform="translate(-9.56 131.54) rotate(-74.44)"/><rect class="cls-2" x="13.2" y="12.24" width="2" height="1.5" transform="translate(-2.96 4.28) rotate(-15.56)"/><path class="cls-2" d="M13.06,68.81,12,64.94l1.45-.4,1.08,3.87Zm-1.77-6.29-1.08-3.87,1.45-.4,1.08,3.87ZM9.53,56.24,8.45,52.37,9.89,52,11,55.83ZM7.77,50,6.69,46.08l1.44-.41,1.09,3.87ZM6,43.66,4.93,39.79l1.44-.41,1.09,3.87ZM4.25,37.37,3.16,33.5l1.45-.41L5.69,37ZM2.49,31.08,1.4,27.21l1.45-.41,1.08,3.88ZM.73,24.79.25,23.1A6.66,6.66,0,0,1,0,21.28a5.37,5.37,0,0,1,0-.7l1.49.15a5.07,5.07,0,0,0,.17,2l.47,1.7ZM2.2,18.66.9,17.91A6.71,6.71,0,0,1,4.26,15l.55,1.39A5.28,5.28,0,0,0,2.2,18.66Zm5-2.94-.4-1.44,3.87-1.07.4,1.44Z"/><rect class="cls-2" x="13.98" y="71.01" width="1.5" height="2" transform="matrix(0.96, -0.27, 0.27, 0.96, -18.87, 6.64)"/><path class="cls-3" d="M49.86,57.79A5.67,5.67,0,0,1,53.3,59,5.64,5.64,0,1,0,45,66.35a5.57,5.57,0,0,1-.82-2.91A5.65,5.65,0,0,1,49.86,57.79Z"/><path class="cls-2" d="M48.47,68.28a6.4,6.4,0,1,1,6.39-6.4A6.41,6.41,0,0,1,48.47,68.28Zm0-11.3a4.9,4.9,0,1,0,4.89,4.9A4.91,4.91,0,0,0,48.47,57Z"/></g></g></svg>';
      '<svg fill="none" height="93" width="79" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><linearGradient id="a"><stop offset="0" stop-color="#8fa1b0"/><stop offset="1" stop-color="#5f7083"/></linearGradient><linearGradient id="b" gradientUnits="userSpaceOnUse" x1="76.855" x2="73.677" xlink:href="#a" y1="32.373" y2="32.429"/><linearGradient id="c" gradientUnits="userSpaceOnUse" x1="73.679" x2="70.798" xlink:href="#a" y1="28.977" y2="30.32"/><linearGradient id="d" gradientUnits="userSpaceOnUse" x1="78.063" x2="75.282" xlink:href="#a" y1="36.804" y2="35.263"/><linearGradient id="e" gradientUnits="userSpaceOnUse" x1="4.457" x2="7.631" xlink:href="#a" y1="26.506" y2="26.672"/><linearGradient id="f" gradientUnits="userSpaceOnUse" x1="7.749" x2="10.581" xlink:href="#a" y1="23.222" y2="24.665"/><linearGradient id="g" gradientUnits="userSpaceOnUse" x1="3.095" x2="5.927" xlink:href="#a" y1="30.891" y2="29.448"/><linearGradient id="h"><stop offset="0" stop-color="#afb8c3"/><stop offset="1" stop-color="#cdd6e2"/></linearGradient><linearGradient id="i" gradientUnits="userSpaceOnUse" x1="46.028" x2="75.185" xlink:href="#h" y1="35.143" y2="71.916"/><linearGradient id="j" gradientUnits="userSpaceOnUse" x1="42.028" x2="71.185" xlink:href="#h" y1="30.143" y2="66.916"/><linearGradient id="k" gradientUnits="userSpaceOnUse" x1="23.456" x2="52.613" xlink:href="#h" y1="34.183" y2="70.956"/><linearGradient id="l" gradientUnits="userSpaceOnUse" x1="18.456" x2="47.613" xlink:href="#h" y1="30.183" y2="66.957"/><linearGradient id="m" gradientUnits="userSpaceOnUse" x1="29.046" x2="31.688" y1="24.096" y2="45.608"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#fff" stop-opacity=".158"/></linearGradient><filter id="n" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="59.064" width="49.73" x="27.978" y="31.579"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_319_15363" stdDeviation="2"/></filter><filter id="o" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="73.121" width="64.787" x=".004" y="18.904"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feColorMatrix in="SourceAlpha" result="hardAlpha" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"/><feOffset dy="2.851"/><feGaussianBlur stdDeviation="3.96"/><feColorMatrix values="0 0 0 0 0.172116 0 0 0 0 0.224928 0 0 0 0 0.401945 0 0 0 0.160921 0"/><feBlend in2="BackgroundImageFix" result="effect1_dropShadow_319_15363"/><feBlend in="SourceGraphic" in2="effect1_dropShadow_319_15363" result="shape"/></filter><filter id="p" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="59.064" width="49.73" x="11.142" y="26.19"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_319_15363" stdDeviation="2"/></filter><mask id="q" height="56" maskUnits="userSpaceOnUse" width="47" x="25" y="28"><rect fill="#fff" height="49.276" rx="1.426" stroke="#fff" stroke-width="2.218" transform="matrix(.99254615 .12186934 -.12186934 .99254615 3.815448 -3.768018)" width="38.555" x="32.711" y="29.307"/></mask><mask id="r" height="57" maskUnits="userSpaceOnUse" width="48" x="7" y="23"><rect fill="#fff" height="49.276" rx="1.426" stroke="#fff" stroke-width="2.218" transform="matrix(.99254615 -.12186934 .12186934 .99254615 -3.543411 1.301749)" width="38.555" x="8.87" y="29.618"/></mask><circle cx="43.5" cy="23.5" opacity=".4" r="22.5" stroke="#686b89" stroke-dasharray="2 9" stroke-linecap="round"/><g opacity=".5"><path d="m74.41 34.455 2.205-1.19a.468.468 0 0 0 .19-.638.48.48 0 0 0 -.647-.188l-2.205 1.19a.468.468 0 0 0 -.19.639.48.48 0 0 0 .647.187z" fill="url(#b)"/><path d="m72.293 31.873 1.53-1.983a.468.468 0 0 0 -.086-.661.48.48 0 0 0 -.668.092l-1.53 1.983a.468.468 0 0 0 .087.661.48.48 0 0 0 .667-.092z" fill="url(#c)"/><path d="m74.904 37.384 2.504.072a.468.468 0 0 0 .484-.458.48.48 0 0 0 -.466-.486l-2.504-.072a.468.468 0 0 0 -.484.459.48.48 0 0 0 .466.485z" fill="url(#d)"/></g><g opacity=".5"><path d="m6.827 28.672-2.162-1.266a.468.468 0 0 1 -.167-.645.48.48 0 0 1 .653-.165l2.161 1.266a.468.468 0 0 1 .168.645.48.48 0 0 1 -.653.165z" fill="url(#e)"/><path d="m9.033 26.165-1.46-2.035a.468.468 0 0 1 .11-.658.48.48 0 0 1 .663.115l1.46 2.036a.468.468 0 0 1 -.11.657.48.48 0 0 1 -.663-.115z" fill="url(#f)"/><path d="m6.23 31.582-2.504-.015a.468.468 0 0 1 -.468-.475.48.48 0 0 1 .483-.47l2.505.016a.468.468 0 0 1 .468.475.48.48 0 0 1 -.483.469z" fill="url(#g)"/></g><g filter="url(#n)" opacity=".44"><rect fill="url(#i)" height="47.058" rx=".317" transform="matrix(.99254615 .12186934 -.12186934 .99254615 4.612441 -4.326739)" width="36.338" x="37.677" y="35.543"/></g><rect fill="url(#j)" height="49.276" rx="1.426" stroke="#fff" stroke-width="2.218" transform="matrix(.99254615 .12186934 -.12186934 .99254615 3.815448 -3.768018)" width="38.555" x="32.711" y="29.307"/><g mask="url(#q)"><g clip-rule="evenodd" fill-rule="evenodd"><path d="m39.823 39.881 7.697-6.838 2.578 7.488z" fill="#acff8f"/><path d="m47.458 52.79 4.085-9.45 5.502 5.696z" fill="#a9b6c3"/><path d="m59.693 61.043.069-10.296 7.29 3.095-7.359 7.2z" fill="#95a0ac"/></g><path d="m47.418 27.683s.598 19.314 19.943 25.872" stroke="#fff" stroke-width=".95"/></g><path d="m28.325 64.994 38.43 4.719-1.557 12.672-38.429-4.718z" fill="#fff"/><rect fill="#e5e9f5" height="2.218" rx="1.109" transform="matrix(.99254615 .12186934 -.12186934 .99254615 8.652231 -3.018728)" width="30.412" x="29.004" y="69.222"/><rect fill="#e5e9f5" height="2.218" rx="1.109" transform="matrix(.99254615 .12186934 -.12186934 .99254615 9.155027 -2.94137)" width="17.74" x="28.623" y="73.371"/><g filter="url(#o)"><g filter="url(#p)" opacity=".44"><rect fill="url(#k)" height="47.058" rx=".317" transform="matrix(.99254615 -.12186934 .12186934 .99254615 -4.102017 2.098613)" width="36.338" x="15.105" y="34.583"/></g><rect fill="url(#l)" height="49.276" rx="1.426" stroke="#fff" stroke-width="2.218" transform="matrix(.99254615 -.12186934 .12186934 .99254615 -3.543411 1.301749)" width="38.555" x="8.87" y="29.618"/><g clip-rule="evenodd" fill-rule="evenodd" mask="url(#r)"><path d="m37.433 10.956a9.294 9.294 0 0 1 7.137 2.094 11.673 11.673 0 0 1 7.373-3.875c6.334-.778 12.085 3.603 12.844 9.785.036.298.06.595.073.89 4.154 1.29 7.363 4.841 7.917 9.35.76 6.182-3.76 11.824-10.095 12.602-3.695.454-7.192-.848-9.614-3.239-1.747 2.885-4.99 5.032-8.903 5.512-4.86.597-9.34-1.55-11.471-5.098a10.6 10.6 0 0 1 -1.056.184c-5.495.675-10.473-3.047-11.12-8.313-.646-5.266 3.284-10.082 8.779-10.757l.04-.005c-.122-4.548 3.347-8.547 8.096-9.13z" fill="url(#m)"/><path d="m37.75 54.408a15.523 15.523 0 0 1 16.035-2.828l27.135 10.763-64.99 11.46 21.818-19.395z" fill="#a9b6c4"/><path d="m13.684 49.358a11.721 11.721 0 0 1 14.903-1.83l25.757 16.619-61.632 7.567z" fill="#95a0ac"/></g><path d="m13.247 65.306 38.43-4.719 1.555 12.673-38.429 4.719z" fill="#fff"/><g fill="#e5e9f5"><rect height="2.218" rx="1.109" transform="matrix(.99254615 -.12186934 .12186934 .99254615 -8.327435 2.335644)" width="30.412" x="14.929" y="69.244"/><rect height="2.218" rx="1.109" transform="matrix(.99254615 -.12186934 .12186934 .99254615 -8.824575 2.443482)" width="17.74" x="15.563" y="73.362"/></g></g><path d="m39.948 8.655 5.1 8.555-1.059.657-5.406-8.364zm6.759 12.283c-.242.15-.509.175-.802.076-.293-.1-.53-.295-.713-.589a1.333 1.333 0 0 1 -.212-.9c.042-.306.183-.535.424-.685.232-.144.49-.163.774-.058.293.099.531.295.713.588.182.294.253.594.212.9-.032.302-.164.524-.396.668z" fill="#ff9f1c"/></svg>';
  static final _svgEmpty = Center(
      child: SizedBox(
          child: SvgPicture.string(
    _empty,
    height: 160,
    width: 160,
  )));
  final String _imgAddres;
  final String? caption;
  final String? tag;
  final Color? color;
  final BoxFit fit;
  final bool isZoomabel;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  late final ImageProvider imageProvider;

  late final Widget? failed;

  final BlendMode blendMode = BlendMode.multiply;

  ImageWidget.asset(
    String address, {
    Key? key,
    this.alignment = Alignment.center,
    this.color,
    Widget? failed,
    this.caption,
    this.tag,
    this.isZoomabel = false,
    this.fit = BoxFit.contain,
    this.repeat = ImageRepeat.noRepeat,
  })  : assert(isZoomabel ? caption != null : true),
        _imgAddres = address,
        super(key: key) {
    if (failed == null) {
      this.failed = _svgEmpty;
    } else {
      this.failed = failed;
    }
    if (isSVGFormat(_imgAddres)) {
      imageProvider =
          SVGCacherProvider(_imgAddres, source: SvgSource.asset, cacheManager: DefaultCacheManager()
              // color: widget.color,
              );
    } else {
      imageProvider = AssetImage(
        _imgAddres,
      );
    }
  }

  ImageWidget.network(
    String url, {
    Key? key,
    this.isZoomabel = false,
    this.color,
    Widget? failed,
    this.caption,
    this.tag,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.repeat = ImageRepeat.noRepeat,
  })  : assert(isZoomabel ? caption != null : true),
        _imgAddres = url,
        super(key: key) {
    if (failed == null) {
      this.failed = _svgEmpty;
    } else {
      this.failed = failed;
    }
    if (isSVGFormat(_imgAddres)) {
      imageProvider = SVGCacherProvider(
        _imgAddres,
        source: SvgSource.network, cacheManager: DefaultCacheManager(),
        // color: widget.color,
      );
    } else {
      imageProvider = CachedNetworkImageProvider(kIsWeb ? _imgAddres.updateImageUrl() : _imgAddres);
    }
  }

  ImageWidget.file(
    String url, {
    Key? key,
    this.isZoomabel = false,
    Widget? failed,
    this.color,
    this.caption,
    this.tag,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.repeat = ImageRepeat.noRepeat,
  })  : assert(isZoomabel ? caption != null : true),
        _imgAddres = url,
        super(key: key) {
    if (failed == null) {
      this.failed = _svgEmpty;
    } else {
      this.failed = failed;
    }
    if (isSVGFormat(_imgAddres)) {
      imageProvider = SVGCacherProvider(_imgAddres,
          source: SvgSource.network, cacheManager: DefaultCacheManager()
          // color: widget.color,
          );
    } else {
      imageProvider = FileImage(
        File(_imgAddres),
      );
    }
  }

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  int? size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      var box = context.findRenderObject() as RenderBox?;
      size = max(box?.size.height.round() ?? 0, box?.size.width.round() ?? 0);
      size = size == 0 ? 100 : size;
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var tag = widget.tag ?? widget._imgAddres.split('/').last;
    return GestureDetector(
      onTap: widget.isZoomabel
          ? () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GalleryViewer(
                  items: [Image(image: widget.imageProvider)],
                  selectedIndex: 0,
                  title: '',
                ),
              ));
            }
          : null,
      child: (widget.tag != null)
          ? Hero(
              tag: tag,
              child: _getImage(
                  failed: widget.failed,
                  alignment: widget.alignment,
                  imgProvider: widget.imageProvider,
                  color: widget.color,
                  fit: widget.fit,
                  repeat: widget.repeat,
                  onErrorRefresh: () {
                    setState(() {});
                  }),
            )
          : _getImage(
              failed: widget.failed,
              alignment: widget.alignment,
              imgProvider: widget.imageProvider,
              color: widget.color,
              fit: widget.fit,
              repeat: widget.repeat,
              onErrorRefresh: () {
                setState(() {});
              }),
    );
  }
}

bool isSVGFormat(String url) {
  Uri? uri = Uri.tryParse(url);
  if (uri != null && uri.path.toLowerCase().contains('.svg')) return true;
  return false;
}

///retutn image widget by a provider
///form diffrent type of provider
///it has error widget and its click abel
///it has progress downloader
// Image getImage({
//   required ImageProvider imgProvider,
//   Color? color,
//   BoxFit? fit,
//   required ImageRepeat repeat,
//   required AlignmentGeometry alignment,
//   void Function()? onErrorRefresh,
//   Widget? failed,
// }) =>

class _getImage extends StatelessWidget {
  final ImageProvider imgProvider;
  final Color? color;
  final BoxFit? fit;
  final ImageRepeat repeat;
  final AlignmentGeometry alignment;
  final void Function()? onErrorRefresh;
  final Widget? failed;

  const _getImage(
      {required this.imgProvider,
      this.color,
      this.fit,
      required this.repeat,
      required this.alignment,
      this.onErrorRefresh,
      this.failed});

// ImageChunkEvent? lastLoadingProgress;

  @override
  Widget build(BuildContext context) => Image(
        // colorBlendMode: BlendMode.multiply,
        // color: Colors.grey.withOpacity(0.1),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return Container(
            // color: Colors.grey.shade50,
            child: const Center(
              child: LoadingWidget(),
            ),
          );
        },
        key: UniqueKey(),
        image: imgProvider,
        color: color,
        fit: fit,
        repeat: repeat,
        // cacheHeight: size,
        // cacheWidth: size,
        alignment: alignment,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Container(
              color: Colors.grey.shade50,
              child: Center(
                child: LoadingWidget(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          }
        },
        errorBuilder: (BuildContext context, Object obj, StackTrace? stackTrace) {
          return Container(
            color: Colors.grey.shade50,
            child: failed ??
                const Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                ),
          );
        },
      );
}

Future<File?> getFileFromImageProvider({ImageProvider? imageProvider}) async {
  if (imageProvider is AssetImage) {
    AssetImage assetImage = imageProvider.runtimeType as AssetImage;
    var data = await rootBundle.load(assetImage.assetName);

    return await File('path').writeAsBytes(data.buffer.asUint8List());
  } else if (imageProvider is FileImage) {
    FileImage fileImage = imageProvider.runtimeType as FileImage;
    File file = fileImage.file;
    return file;
  } else if (imageProvider is CachedNetworkImageProvider) {
    File x = await (imageProvider).cacheManager!.getSingleFile(imageProvider.url);
    // if (kDebugMode) {
    //   print(x.path);
    // }
    return x;
  } else if (imageProvider is MemoryImage) {
  } else {}
  // return File('');
  return null;
}

Future<Color?> paletteFromImageProvider(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
    imageProvider,
    maximumColorCount: 20,
  );
  return paletteGenerator.dominantColor?.color;
}

Future<Color?> paletteFromImage(ui.Image image) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImage(image);
  return paletteGenerator.dominantColor?.color;
}
