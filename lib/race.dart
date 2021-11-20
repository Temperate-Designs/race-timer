import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  static const AdRequest request = AdRequest();
  BannerAd? _ad;
  bool _isAdLoaded = false;
  bool _raceStarted = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  static const startIcon = Icon(Icons.play_arrow_outlined);
  static const stopIcon = Icon(Icons.stop_outlined);

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

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

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _ad?.dispose();
  }

  void arrangeRacers() {
    List<Racer> stillRunning =
        List.from(widget.race.racers.where((racer) => racer.isRunning));
    stillRunning.sort((a, b) => a.bibNumber.compareTo(b.bibNumber));
    List<Racer> finished =
        List.from(widget.race.racers.where((racer) => !racer.isRunning));
    finished.sort((a, b) =>
        (a.finalMilliseconds - a.startMilliseconds) -
        (b.finalMilliseconds - b.startMilliseconds));
    widget.race.racers = stillRunning + finished;
  }

  List<Racer> stillRunning() {
    return List.from(widget.race.racers.where((racer) => racer.isRunning));
  }

  void handleStart({Racer? racer, int? group}) {
    switch (widget.race.type) {
      case RaceType.mass:
        if (!_stopwatch.isRunning && !_raceStarted) {
          // Start the race
          _raceStarted = true;
          _stopwatch.start();
          for (var racer in widget.race.racers) {
            racer.hasStarted = true;
          }
          // Make sure we re-render the app frequently so that the stopwatch is updated.
          _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
            setState(() {});
          });
          // Re-render app now.
          setState(() {});
        }
        break;
      case RaceType.group:
        if (!_stopwatch.isRunning && !_raceStarted) {
          // Start the race
          _raceStarted = true;
          _stopwatch.start();
          // Make sure we re-render the app frequently so that the stopwatch is updated.
          _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
            setState(() {});
          });
          // Re-render app now.
          setState(() {});
        }
        if (group == null) {
          debugPrint('group cannot be null');
        }
        widget.race.racers.where((r) => r.groupNumber == group).forEach((r) {
          r.hasStarted = true;
          r.startMilliseconds = _stopwatch.elapsedMilliseconds;
        });
        break;
      case RaceType.individual:
        if (!_stopwatch.isRunning && !_raceStarted) {
          // Start the race
          _raceStarted = true;
          _stopwatch.start();
          // Make sure we re-render the app frequently so that the stopwatch is updated.
          _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
            setState(() {});
          });
          // Re-render app now.
          setState(() {});
        }
        if (racer == null) {
          debugPrint('racer cannot be null');
        }
        racer?.hasStarted = true;
        racer?.startMilliseconds = _stopwatch.elapsedMilliseconds;
        break;
    }
  }

  void handleStop({Racer? racer, int? group}) {
    switch (widget.race.type) {
      case RaceType.mass:
        if (_stopwatch.isRunning) {
          if (racer != null && racer.isRunning) {
            racer.isRunning = false;
            racer.finalMilliseconds = _stopwatch.elapsedMilliseconds;
            arrangeRacers();
            setState(() {});
          }
          if (racer == null || stillRunning().isEmpty) {
            _stopwatch.stop();
            _timer?.cancel();
            setState(() {});
          }
        }
        break;
      case RaceType.group:
      case RaceType.individual:
        if (_stopwatch.isRunning) {
          if (racer != null && racer.isRunning) {
            racer.isRunning = false;
            racer.finalMilliseconds = _stopwatch.elapsedMilliseconds;
            arrangeRacers();
            setState(() {});
          }
          if (racer == null || stillRunning().isEmpty) {
            _stopwatch.stop();
            _timer?.cancel();
            setState(() {});
          }
        }
        break;
    }
  }

  Ink getStartStopButton(
      {required Color backgroundColor,
      required String tooltip,
      required Icon icon,
      required Function()? onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: icon,
        tooltip: tooltip,
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }

  Widget racerStartStopButton([Racer? racer]) {
    switch (widget.race.type) {
      case RaceType.mass:
        if (_stopwatch.isRunning) {
          return getStartStopButton(
            backgroundColor: Colors.red,
            tooltip: 'End Race',
            icon: stopIcon,
            onPressed: () {
              if (racer != null && racer.isRunning) {
                handleStop(racer: racer);
              }
            },
          );
        } else {
          if (racer == null) {
            return getStartStopButton(
              tooltip: 'Start Race',
              backgroundColor: Colors.green,
              icon: startIcon,
              onPressed: () {
                handleStart();
              },
            );
          } else {
            return getStartStopButton(
              tooltip: 'Start Race',
              backgroundColor: Colors.grey,
              icon: startIcon,
              onPressed: null,
            );
          }
        }
      case RaceType.group:
        if (!_stopwatch.isRunning) {
          if (racer == null) {
            return getStartStopButton(
              tooltip: 'Start Race',
              backgroundColor: Colors.grey,
              icon: startIcon,
              onPressed: () {},
            );
          } else {
            return getStartStopButton(
              tooltip: 'Start Race',
              backgroundColor: Colors.blue,
              icon: startIcon,
              onPressed: () {
                handleStart(group: racer.groupNumber);
              },
            );
          }
        } else {
          if (racer != null) {
            if (racer.hasStarted) {
              return getStartStopButton(
                tooltip: 'Stop Racer',
                backgroundColor: Colors.red,
                icon: stopIcon,
                onPressed: () {
                  handleStop(racer: racer);
                },
              );
            } else {
              return getStartStopButton(
                tooltip: 'Start Group',
                backgroundColor: Colors.blue,
                icon: startIcon,
                onPressed: () {
                  handleStart(group: racer.groupNumber);
                },
              );
            }
          }
          return getStartStopButton(
            tooltip: 'End Race',
            backgroundColor: Colors.grey,
            icon: stopIcon,
            onPressed: () {},
          );
        }
      case RaceType.individual:
        if (!_stopwatch.isRunning) {
          if (racer == null) {
            return getStartStopButton(
              tooltip: 'Start Race',
              backgroundColor: Colors.grey,
              icon: startIcon,
              onPressed: () {},
            );
          } else {
            return getStartStopButton(
              tooltip: 'Start Race',
              backgroundColor: Colors.blue,
              icon: startIcon,
              onPressed: () {
                handleStart(racer: racer);
              },
            );
          }
        } else {
          if (racer != null) {
            if (racer.hasStarted) {
              return getStartStopButton(
                tooltip: 'Stop Racer',
                backgroundColor: Colors.red,
                icon: stopIcon,
                onPressed: () {
                  handleStop(racer: racer);
                },
              );
            } else {
              return getStartStopButton(
                tooltip: 'Start Racer',
                backgroundColor: Colors.blue,
                icon: startIcon,
                onPressed: () {
                  handleStart(racer: racer);
                },
              );
            }
          }
          return getStartStopButton(
            tooltip: 'End Race',
            backgroundColor: Colors.grey,
            icon: stopIcon,
            onPressed: () {},
          );
        }
    }
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
                              // FIXME: This color is not showing up.
                              color: Colors.lightBlue,
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
                      Row(
                        children: [
                          Text('Name: ${widget.race.name}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Type: ${widget.race.type}'),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.race.racers.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                isThreeLine: false,
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.amber,
                                ),
                                title: Text(
                                  widget.race.racers[index].name,
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
                                trailing: const IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: null,
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
