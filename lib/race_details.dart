import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swn_race_timer/race_state_model.dart';

class RaceDetailsWidget extends StatefulWidget {
  final int raceIndex;
  const RaceDetailsWidget({Key? key, required this.raceIndex})
      : super(key: key);

  @override
  _RaceDetailsWidgetState createState() => _RaceDetailsWidgetState();
}

class _RaceDetailsWidgetState extends State<RaceDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const AdRequest request = AdRequest();
  BannerAd? _ad;
  bool _isAdLoaded = false;

  @override
  RaceDetailsWidget get widget => super.widget;

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
              'Race Details',
            ),
            actions: const [],
            centerTitle: true,
            elevation: 4,
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Stack(
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Image.asset(
                    'assets/images/background.jpg',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_ad != null)
                      Container(
                        child: AdWidget(ad: _ad!),
                        width: _ad!.size.width.toDouble(),
                        height: _ad!.size.height.toDouble(),
                        alignment: Alignment.center,
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0x00EEEEEE),
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Date: ${DateFormat('d LLL y').format(model.races[widget.raceIndex].date!)}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${model.races[widget.raceIndex].racers.length} racers',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${model.races[widget.raceIndex].type.toRaceTypeString()} starts',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: model.races[widget.raceIndex].racers.length,
                        itemBuilder: (context, index) => Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: const Color(0x00F5F5F5),
                          child: ListTile(
                            isThreeLine: false,
                            title: Text(
                              model.races[widget.raceIndex].racers[index].name,
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            subtitle: Text(
                              'Bib: ${model.races[widget.raceIndex].racers[index].bibNumber.toString().padLeft(3, '0')}\n'
                              'Group ${model.races[widget.raceIndex].racers[index].groupNumber.toString().padLeft(2, '0')}\n'
                              'Time: ${model.races[widget.raceIndex].racers[index].time()}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            tileColor: const Color(0xFFF5F5F5),
                            dense: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
