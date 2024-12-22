import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdService {
  final log = Logger(printer: PrettyPrinter());

  static String get bannerAdUnitId {
    // Main ad unit ID: ca-app-pub-8576327986501059/9108764525
    // Replace with your ad unit ID
    return 'ca-app-pub-3940256099942544/9214589741'; // Test ad unit ID
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
          print('\n\n*****************\n Ad failed to load: $error \n\n**********************\n');
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
