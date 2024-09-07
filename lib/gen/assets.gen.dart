/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// Directory path: assets/fonts/Poppins
  $AssetsFontsPoppinsGen get poppins => const $AssetsFontsPoppinsGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/house1.jpg
  AssetGenImage get house1 => const AssetGenImage('assets/images/house1.jpg');

  /// File path: assets/images/house2.jpg
  AssetGenImage get house2 => const AssetGenImage('assets/images/house2.jpg');

  /// File path: assets/images/house3.jpg
  AssetGenImage get house3 => const AssetGenImage('assets/images/house3.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [house1, house2, house3];
}

class $AssetsFontsPoppinsGen {
  const $AssetsFontsPoppinsGen();

  /// File path: assets/fonts/Poppins/OFL.txt
  String get ofl => 'assets/fonts/Poppins/OFL.txt';

  /// File path: assets/fonts/Poppins/Poppins-Black.ttf
  String get poppinsBlack => 'assets/fonts/Poppins/Poppins-Black.ttf';

  /// File path: assets/fonts/Poppins/Poppins-BlackItalic.ttf
  String get poppinsBlackItalic =>
      'assets/fonts/Poppins/Poppins-BlackItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-Bold.ttf
  String get poppinsBold => 'assets/fonts/Poppins/Poppins-Bold.ttf';

  /// File path: assets/fonts/Poppins/Poppins-BoldItalic.ttf
  String get poppinsBoldItalic => 'assets/fonts/Poppins/Poppins-BoldItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-ExtraBold.ttf
  String get poppinsExtraBold => 'assets/fonts/Poppins/Poppins-ExtraBold.ttf';

  /// File path: assets/fonts/Poppins/Poppins-ExtraBoldItalic.ttf
  String get poppinsExtraBoldItalic =>
      'assets/fonts/Poppins/Poppins-ExtraBoldItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-ExtraLight.ttf
  String get poppinsExtraLight => 'assets/fonts/Poppins/Poppins-ExtraLight.ttf';

  /// File path: assets/fonts/Poppins/Poppins-ExtraLightItalic.ttf
  String get poppinsExtraLightItalic =>
      'assets/fonts/Poppins/Poppins-ExtraLightItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-Italic.ttf
  String get poppinsItalic => 'assets/fonts/Poppins/Poppins-Italic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-Light.ttf
  String get poppinsLight => 'assets/fonts/Poppins/Poppins-Light.ttf';

  /// File path: assets/fonts/Poppins/Poppins-LightItalic.ttf
  String get poppinsLightItalic =>
      'assets/fonts/Poppins/Poppins-LightItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-Medium.ttf
  String get poppinsMedium => 'assets/fonts/Poppins/Poppins-Medium.ttf';

  /// File path: assets/fonts/Poppins/Poppins-MediumItalic.ttf
  String get poppinsMediumItalic =>
      'assets/fonts/Poppins/Poppins-MediumItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-Regular.ttf
  String get poppinsRegular => 'assets/fonts/Poppins/Poppins-Regular.ttf';

  /// File path: assets/fonts/Poppins/Poppins-SemiBold.ttf
  String get poppinsSemiBold => 'assets/fonts/Poppins/Poppins-SemiBold.ttf';

  /// File path: assets/fonts/Poppins/Poppins-SemiBoldItalic.ttf
  String get poppinsSemiBoldItalic =>
      'assets/fonts/Poppins/Poppins-SemiBoldItalic.ttf';

  /// File path: assets/fonts/Poppins/Poppins-Thin.ttf
  String get poppinsThin => 'assets/fonts/Poppins/Poppins-Thin.ttf';

  /// File path: assets/fonts/Poppins/Poppins-ThinItalic.ttf
  String get poppinsThinItalic => 'assets/fonts/Poppins/Poppins-ThinItalic.ttf';

  /// List of all assets
  List<String> get values => [
        ofl,
        poppinsBlack,
        poppinsBlackItalic,
        poppinsBold,
        poppinsBoldItalic,
        poppinsExtraBold,
        poppinsExtraBoldItalic,
        poppinsExtraLight,
        poppinsExtraLightItalic,
        poppinsItalic,
        poppinsLight,
        poppinsLightItalic,
        poppinsMedium,
        poppinsMediumItalic,
        poppinsRegular,
        poppinsSemiBold,
        poppinsSemiBoldItalic,
        poppinsThin,
        poppinsThinItalic
      ];
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
