import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swn_race_timer/edit_racer.dart';
import 'package:swn_race_timer/race_details.dart';
import 'package:swn_race_timer/race_state_model.dart';

class SWNRaceTimer extends StatefulWidget {
  const SWNRaceTimer({Key? key}) : super(key: key);

  @override
  _SWNRaceTimerState createState() => _SWNRaceTimerState();
}

class _SWNRaceTimerState extends State<SWNRaceTimer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      _isAdLoaded = true;
      _createAnchoredBanner(context);
    }
    log('The context is $context');
    return Consumer<RaceStateModel>(builder: (context, model, child) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.blue),
          automaticallyImplyLeading: true,
          title: const Text(
            'SWN Race Timer',
            style: TextStyle(fontSize: 24),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditRacerWidget(),
              ),
            );
          },
          backgroundColor: Colors.blue,
          icon: const Icon(
            Icons.add,
          ),
          elevation: 8,
          label: const Text(
            'New Race',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/background.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (_ad != null)
                    Container(
                      child: AdWidget(ad: _ad!),
                      width: _ad!.size.width.toDouble(),
                      height: _ad!.size.height.toDouble(),
                      alignment: Alignment.center,
                    ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Text(
                      'Past Races',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.numberOfRaces,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: const Color(0x80F5F5F5),
                          elevation: 2,
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RaceDetailsWidget(raceIndex: index),
                                ),
                              );
                            },
                            child: Slidable(
                              actionPane: const SlidableScrollActionPane(),
                              secondaryActions: [
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.blue,
                                  icon: Icons.delete,
                                  onTap: () {
                                    print('SlidableActionWidget pressed ...');
                                  },
                                ),
                                IconSlideAction(
                                  caption: 'Share',
                                  color: Colors.blue,
                                  icon: Icons.share,
                                  onTap: () {
                                    print('SlidableActionWidget pressed ...');
                                  },
                                )
                              ],
                              child: ListTile(
                                title: Text(
                                  model.races[index].name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  '${DateFormat('d LLL y').format(model.races[index].date)}\n'
                                  '${model.races[index].racers.length} racers',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF303030),
                                  size: 20,
                                ),
                                tileColor: const Color(0xFFF5F5F5),
                                dense: false,
                              ),
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
