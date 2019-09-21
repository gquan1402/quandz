import 'package:firebase_admob/firebase_admob.dart';
import 'package:demon_salyer_wallpaper/constant/admob_constant.dart';

class AdmobAds {
  static InterstitialAd createInterstitialAd(Function function) {
    return InterstitialAd(
      adUnitId: ADMOB_INTERSTITIAL_ID,
      listener: (MobileAdEvent event) {

        if (event == MobileAdEvent.closed ||
            event == MobileAdEvent.failedToLoad) {
          function();
        }
      },
    );
  }
}