import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../exceptions/dublicate_widget_exception.dart';
import 'package:logger/logger.dart';

class AdService extends GetxService {
  static AdService get to => Get.find();
  final log = Logger(printer: PrettyPrinter());
  
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;

  static String get bannerAdUnitId {
    // Main ad unit ID: ca-app-pub-8576327986501059/9108764525
    return 'ca-app-pub-3940256099942544/9214589741'; // Test ad unit ID
  }

  static String get interstitialAdUnitId {
    return 'ca-app-pub-3940256099942544/1033173712'; // Test ad unit ID
  }

  BannerAd createUniqueBannerAd() {
    try {
      return BannerAd(
        adUnitId: bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isAdLoaded.value = true;
            log.i('Banner Ad loaded successfully');
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            isAdLoaded.value = false;
            log.e('Banner Ad failed to load: $error');
          },
        ),
      )..load();
    } catch (e) {
      throw DuplicateAdWidgetException('Failed to create unique banner ad instance');
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          log.i('Interstitial Ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          log.e('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    createUniqueBannerAd();
    loadInterstitialAd();
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    super.onClose();
  }
}
