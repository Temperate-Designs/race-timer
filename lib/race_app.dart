import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import "add_racer.dart";

enum RaceType { individual, group, mass }

class RaceApp extends StatelessWidget {
  final title = 'SWN Race Timer';

  const RaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RaceHomePage(title: title),
        '/add-racer': (context) => AddRacerPage(),
      },
    );
  }
}

class RaceHomePage extends StatefulWidget {
  const RaceHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _RaceHomePageState createState() => _RaceHomePageState();
}

class _RaceHomePageState extends State<RaceHomePage> {
  bool _raceStarted = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  RaceType _raceType = RaceType.individual;

  static const startIcon = Icon(Icons.play_arrow_outlined);
  static const stopIcon = Icon(Icons.stop_outlined);

  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      size: AdSize.banner,
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-4328959315579213/8369004752',
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(
              'Ad load failed (code = ${error.code}, message = ${error.message})');
        },
      ),
      request: const AdRequest(),
    );

    _ad.load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ad.dispose();
    super.dispose();
  }

  void arrangeRacers() {
    List<Racer> stillRunning =
        List.from(racers.where((racer) => racer.isRunning));
    stillRunning.sort((a, b) => a.bibNumber.compareTo(b.bibNumber));
    List<Racer> finished = List.from(racers.where((racer) => !racer.isRunning));
    finished.sort((a, b) =>
        (a.finalMilliseconds - a.startMilliseconds) -
        (b.finalMilliseconds - b.startMilliseconds));
    racers = stillRunning + finished;
  }

  List<Racer> stillRunning() {
    return List.from(racers.where((racer) => racer.isRunning));
  }

  void handleStart({Racer? racer, int? group}) {
    switch (_raceType) {
      case RaceType.mass:
        if (!_stopwatch.isRunning && !_raceStarted) {
          // Start the race
          _raceStarted = true;
          _stopwatch.start();
          for (var racer in racers) {
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
        racers.where((r) => r.group == group).forEach((r) {
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
    switch (_raceType) {
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
      Function()? onPressed}) {
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
    switch (_raceType) {
      case RaceType.mass:
        if (_stopwatch.isRunning) {
          return getStartStopButton(
            backgroundColor: Colors.red,
            tooltip: AppLocalizations.of(context)!.end_race,
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
              tooltip: AppLocalizations.of(context)!.start_race,
              backgroundColor: Colors.green,
              icon: startIcon,
              onPressed: () {
                handleStart();
              },
            );
          } else {
            return getStartStopButton(
              tooltip: AppLocalizations.of(context)!.start_race,
              backgroundColor: Colors.grey,
              icon: startIcon,
              onPressed: () {},
            );
          }
        }
      case RaceType.group:
        if (!_stopwatch.isRunning) {
          if (racer == null) {
            return getStartStopButton(
              tooltip: AppLocalizations.of(context)!.start_race,
              backgroundColor: Colors.grey,
              icon: startIcon,
              onPressed: () {},
            );
          } else {
            return getStartStopButton(
              tooltip: AppLocalizations.of(context)!.start_race,
              backgroundColor: Colors.blue,
              icon: startIcon,
              onPressed: () {
                handleStart(group: racer.group);
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
                  handleStart(group: racer.group);
                },
              );
            }
          }
          return getStartStopButton(
            tooltip: AppLocalizations.of(context)!.end_race,
            backgroundColor: Colors.grey,
            icon: stopIcon,
            onPressed: () {},
          );
        }
      case RaceType.individual:
        if (!_stopwatch.isRunning) {
          if (racer == null) {
            return getStartStopButton(
              tooltip: AppLocalizations.of(context)!.start_race,
              backgroundColor: Colors.grey,
              icon: startIcon,
              onPressed: () {},
            );
          } else {
            return getStartStopButton(
              tooltip: AppLocalizations.of(context)!.start_race,
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
            tooltip: AppLocalizations.of(context)!.end_race,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _stopwatch = Stopwatch();
              _timer?.cancel();
              _raceStarted = false;
              racers = [];
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Future pushedName = Navigator.pushNamed(context, '/add-racer');
              pushedName.then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isAdLoaded
                    ? Container(
                        child: AdWidget(ad: _ad),
                        width: _ad.size.width.toDouble(),
                        height: _ad.size.height.toDouble(),
                        alignment: Alignment.center,
                      )
                    : null,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: CupertinoColors.lightBackgroundGray),
                  child: Text(formatTime(_stopwatch.elapsedMilliseconds),
                      style: const TextStyle(
                          fontSize: 42, fontWeight: FontWeight.bold))),
              racerStartStopButton(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (_raceType == RaceType.individual) {
                        return Colors.red;
                      } else {
                        return Colors.blue;
                      }
                    }),
                  ),
                  child: const Text('Individual'),
                  onPressed: () => setState(() {
                    if (!_raceStarted) {
                      _raceType = RaceType.individual;
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    if (_raceType == RaceType.group) {
                      return Colors.red;
                    } else {
                      return Colors.blue;
                    }
                  })),
                  child: const Text('Group'),
                  onPressed: () => setState(() {
                    if (!_raceStarted) {
                      _raceType = RaceType.group;
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    if (_raceType == RaceType.mass) {
                      return Colors.red;
                    } else {
                      return Colors.blue;
                    }
                  })),
                  child: const Text('Mass'),
                  onPressed: () => setState(() {
                    if (!_raceStarted) {
                      _raceType = RaceType.mass;
                    }
                  }),
                ),
              ),
            ],
          ),
          const Divider(thickness: 2),
          Expanded(
            child: ListView.builder(
              itemCount: racers.length,
              itemBuilder: (context, index) {
                return Material(
                  color: racerCardColor(index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Bib: ${racers[index].bibNumber.toString().padLeft(4, '0')}',
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                'Group: ${racers[index].group.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 16)),
                            Text(racers[index].name,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(6),
                          ),
                        ),
                        Text(
                            formatTime(racers[index].isRunning &&
                                    racers[index].hasStarted
                                ? (_stopwatch.elapsedMilliseconds -
                                    racers[index].startMilliseconds)
                                : (racers[index].finalMilliseconds -
                                    racers[index].startMilliseconds)),
                            style: const TextStyle(fontSize: 32)),
                        const Padding(
                          padding: EdgeInsets.all(6),
                        ),
                        racerStartStopButton(racers[index]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  MaterialColor racerCardColor(int index) {
    if (racers[index].isRunning) {
      if (racers[index].group % 2 == 0) {
        return Colors.lightGreen;
      } else {
        return Colors.green;
      }
    } else {
      if (racers[index].group % 2 == 0) {
        return Colors.blueGrey;
      } else {
        return Colors.grey;
      }
    }
  }
}
