import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  Racer({
    this.name = '',
    this.bibNumber = 1,
  });
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

class RaceTimerApp extends MaterialApp {
  RaceTimerApp({Key? key})
      : super(
          key: key,
          title: "Southwest Nordic Race Timer",
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
  _RaceTimerState createState() => _RaceTimerState();
}

class _RaceTimerState extends State<RaceTimerWidget> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;

  RaceData raceData = RaceData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  Future<String> _getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    String version = '${info.version}+${info.buildNumber}';
    return version;
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
            color: Colors.green,
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
        return Container();
      },
    );
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
          title: const Text('Southwest Nordic Race Timer'),
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
            titleWidget,
            pastRacesWidget(raceData),
            const Spacer(),
            _getAdWidget(),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}

class ShowRaceWidget extends StatelessWidget {
  static const routeName = '/show-race';
  final Race race;

  const ShowRaceWidget({Key? key, required this.race}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Southwest Nordic Race Timer'),
      ),
      body: Column(
        children: [
          Text(race.title),
        ],
      ),
    );
  }
}
