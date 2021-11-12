import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swn_race_timer/race_state_model.dart';

class RaceWidget extends StatefulWidget {
  final Race race;
  const RaceWidget(this.race, {Key? key}) : super(key: key);

  @override
  _RaceWidgetState createState() => _RaceWidgetState();
}

class _RaceWidgetState extends State<RaceWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Stopwatch _stopwatch = Stopwatch();
  static const AdRequest request = AdRequest();
  BannerAd? _ad;
  bool _isAdLoaded = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      log('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-4328959315579213/8369004752',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$BannerAd loaded.');
          setState(() {
            _ad = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void dispose() {
    super.dispose();
    _ad?.dispose();
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hundredths = ((milliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds:$hundredths";
  }

  MaterialColor racerCardColor(int index) {
    if (widget.race.racers[index].isRunning) {
      if (widget.race.racers[index].groupNumber % 2 == 0) {
        return Colors.lightGreen;
      } else {
        return Colors.green;
      }
    } else {
      if (widget.race.racers[index].groupNumber % 2 == 0) {
        return Colors.blueGrey;
      } else {
        return Colors.grey;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      _isAdLoaded = true;
      _createAnchoredBanner(context);
    }
    return Consumer<RaceStateModel>(
      builder: (context, model, child) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              automaticallyImplyLeading: true,
              title: const Text(
                'Race',
                style: TextStyle(fontSize: 24),
              ),
              actions: const [],
              centerTitle: true,
              elevation: 4,
            ),
            backgroundColor: const Color(0xFFF5F5F5),
            body: SafeArea(
              child: Stack(children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Image.asset(
                    'assets/images/background.jpg',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Column(
                    children: [
                      if (_ad != null)
                        Container(
                          child: AdWidget(ad: _ad!),
                          width: _ad!.size.width.toDouble(),
                          height: _ad!.size.height.toDouble(),
                          alignment: Alignment.center,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(10),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Text(
                                  formatTime(_stopwatch.elapsedMilliseconds),
                                  style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold))),
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.green,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow),
                              tooltip: 'Start Race',
                              color: Colors.white,
                              onPressed: () => null,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.race.racers.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                isThreeLine: false,
                                title: Text(
                                  model.pastRaces[index].racers[index].name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                subtitle: Text(
                                  'Bib: ${widget.race.racers[index].bibNumber.toString().padLeft(3, '0')}\n'
                                  'Group ${widget.race.racers[index].groupNumber.toString().padLeft(2, '0')}\n'
                                  'Time: ${widget.race.racers[index].time()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                tileColor: const Color(0xFFF5F5F5),
                                dense: false,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ));
      },
    );
  }
}
