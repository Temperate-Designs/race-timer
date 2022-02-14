import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Race {
  String title = '';
  String description = '';
  List<Racer> racers = [];
}

class Racer {
  String name = '';
}

void main() {
  runApp(const RaceTimerWidget());
}

class RaceTimerWidget extends StatefulWidget {
  const RaceTimerWidget({Key? key}) : super(key: key);

  @override
  _RaceTimerState createState() => _RaceTimerState();
}

class _RaceTimerState extends State<RaceTimerWidget> {
  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    log('Loading ad');

    _ad = BannerAd(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-4328959315579213/8369004752',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('$BannerAd loaded');
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          log('Ad load failed (code=${error.code} message=${error.message})');
        },
        onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
      ),
    );

    // COMPLETE: Load an ad
    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Southwest Nordic Race Timer',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Southwest Nordic Race Timer'),
        ),
        body: FutureBuilder<InitializationStatus>(
          future: _initGoogleMobileAds(),
          builder: (context, snapshot) {
            List<Widget> children = [];

            if (snapshot.connectionState == ConnectionState.waiting) {
              children.add(const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 48.0,
                  height: 48.0,
                ),
              ));
            } else {
              if (snapshot.hasData) {
                if (_isAdLoaded) {
                  children.add(Container(
                    child: AdWidget(ad: _ad),
                    width: _ad.size.width.toDouble(),
                    height: _ad.size.height.toDouble(),
                    alignment: Alignment.center,
                  ));
                }
                children.add(const Text('Past Races'));
              } else if (snapshot.hasError) {
                children.add(Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 8.0),
                      Text('Failed to initialize AdMob SDK'),
                    ],
                  ),
                ));
              }
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}
