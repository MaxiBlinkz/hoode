import 'package:google_mobile_ads/google_mobile_ads.dart';

class DuplicateAdWidgetException implements Exception {
  final String message;
  DuplicateAdWidgetException([this.message = 'Duplicate AdWidget detected in widget tree']);
  
  @override
  String toString() => 'DuplicateAdWidgetException: $message';
}

// Create a unique BannerAd instance for each AdWidget
BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: 'your_ad_unit_id',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    ),
  )..load();
}

// In your widget build method, use it like this:

