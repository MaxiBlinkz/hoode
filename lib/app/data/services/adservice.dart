import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String get bannerAdUnitId {
    // Replace with your ad unit ID
    return 'ca-app-pub-3940256099942544/6300978111'; // Test ad unit ID
  }

  static String get interstitialAdUnitId {
    // Replace with your ad unit ID
    return 'ca-app-pub-3940256099942544/1033173712'; // Test ad unit ID
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Ad loaded.'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    );
  }

  static InterstitialAd? interstitialAd;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}
