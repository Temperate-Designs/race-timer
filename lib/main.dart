import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String appTitleString = "Southwest Nordic Race Timer";
const Text appTitleWidget = Text(appTitleString);

class Race {
  String title;
  String description;
  DateTime date;
  List<Racer> racers;

  Race({
    this.title = '',
    this.description = '',
    DateTime? date,
    this.racers = const [],
  }) : date = date ?? DateTime.now();
}

class Racer {
  String name;
  int bibNumber;
  DateTime startTime;
  DateTime finishTime;

  Racer({
    this.name = '',
    this.bibNumber = 1,
    DateTime? startTime,
    DateTime? finishTime,
  })  : startTime = startTime ?? DateTime.now(),
        finishTime =
            finishTime ?? DateTime.now().add(const Duration(minutes: 5));
}

class RaceData {
  final List<Race> _races = [];
  DateFormat dateformat = DateFormat.yMd();

  RaceData() {
    if (kDebugMode) {
      add(Race(
        title: 'JNQ Minturn',
        description: 'Individual starts, classic',
        date: DateTime(2022, 02, 19),
        racers: [
          Racer(
            name: 'Anthony Adams',
            bibNumber: 1,
          ),
          Racer(
            name: 'Ben Beyer',
            bibNumber: 2,
          ),
          Racer(
            name: 'Charlie Chum',
            bibNumber: 3,
          ),
        ],
      ));
      add(Race(
          title: 'JNQ Minturn',
          description: 'Mass starts, skate',
          date: DateTime(2022, 02, 20),
          racers: [
            Racer(
              name: 'Anthony Adams',
              bibNumber: 1,
            ),
          ]));
      add(Race(
          title: 'Funrace Durango',
          description: 'Mass starts, classic',
          date: DateTime(2022, 02, 28),
          racers: [
            Racer(
              name: 'Anthony Adams',
              bibNumber: 1,
            ),
          ]));
    }
  }

  UnmodifiableListView<Race> get races => UnmodifiableListView(_races);

  void add(Race newRace) {
    _races.add(newRace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(RaceTimerApp());
}

abstract class AdMobState<T extends StatefulWidget> extends State<T> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;

  @override
  void dispose() {
    log('Disposing of ad');
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  Future<void> _loadAd() async {
    log('Loading new Ad');

    await _anchoredAdaptiveAd?.dispose();
    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      log('Unable to get height of anchored banner');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? (kDebugMode
              ? 'ca-app-pub-3940256099942544/6300978111'
              : 'ca-app-pub-4328959315579213/8369004752')
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdClicked: (ad) => log('$ad clicked'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('Ad failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  Widget _getAdWidget() {
    log('Getting Ad widget');
    return OrientationBuilder(
      builder: (context, orientation) {
        log('Checking if orientation has changed');
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          log('Same orientation');
          return Container(
            color: Colors.orange,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          log('Orientation has changed, reloading ad...');
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container(
          height: 60,
        );
      },
    );
  }
}

class RaceTimerApp extends MaterialApp {
  RaceTimerApp({Key? key})
      : super(
          key: key,
          title: appTitleString,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == ShowRaceWidget.routeName) {
              final race = settings.arguments as Race;
              return MaterialPageRoute(
                  builder: (context) => ShowRaceWidget(race: race));
            }
            return null;
          },
          home: const RaceTimerWidget(),
        );
}

class RaceTimerWidget extends StatefulWidget {
  const RaceTimerWidget({Key? key}) : super(key: key);

  @override
  _RaceTimerWidgetState createState() => _RaceTimerWidgetState();
}

class _RaceTimerWidgetState extends AdMobState<RaceTimerWidget> {
  RaceData raceData = RaceData();

  Future<String> _getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    String version = '${info.version}+${info.buildNumber}';
    return version;
  }

  Widget titleWidget = const Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      'Past Races',
      style: TextStyle(fontSize: 20.0),
    ),
  );

  Widget pastRacesWidget(RaceData raceData) => Expanded(
        child: ListView.builder(
            itemCount: raceData.races.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.pushNamed(context, '/show-race',
                    arguments: raceData.races[index]),
                child: Column(
                  children: [
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(color: Colors.orange),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(raceData.races[index].title),
                              Text(raceData.dateformat
                                  .format(raceData.races[index].date)),
                            ],
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(raceData.races[index].description),
                              Text(
                                  '${raceData.races[index].racers.length} racer' +
                                      (raceData.races[index].racers.length > 1
                                          ? 's'
                                          : '')),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appTitleWidget,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'App Info',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _getPackageInfo(),
                    builder: (context, snapshot) => Text(snapshot.hasData
                        ? 'Version: ${snapshot.data}'
                        : 'Loading...'),
                  )),
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _getAdWidget(),
            titleWidget,
            pastRacesWidget(raceData),
          ],
        ));
  }
}

class ShowRaceWidget extends StatefulWidget {
  static const routeName = '/show-race';
  final Race race;
  const ShowRaceWidget({Key? key, required this.race}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _ShowRaceWidgetState createState() => _ShowRaceWidgetState(race: race);
}

class _ShowRaceWidgetState extends AdMobState<ShowRaceWidget> {
  final Race race;

  _ShowRaceWidgetState({required this.race});

  Widget titleWidget(String name) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Race Details - $name',
          style: const TextStyle(fontSize: 20.0),
        ),
      );

  Widget raceDetailsWidget(Race race) => Expanded(
        child: ListView.builder(
            itemCount: race.racers.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  children: [
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(color: Colors.orange),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "(${race.racers[index].bibNumber}) ${race.racers[index].name}"),
                              Text(race.racers[index].finishTime
                                  .difference(race.racers[index].startTime)
                                  .toString()),
                            ],
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitleWidget,
      ),
      body: Column(
        children: [
          _getAdWidget(),
          titleWidget(race.title),
          raceDetailsWidget(race),
        ],
      ),
    );
  }
}
