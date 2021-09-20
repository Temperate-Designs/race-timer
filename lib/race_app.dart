import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import "add_racer.dart";

class RaceApp extends StatelessWidget {
  final title = 'SWN Race Timer';

  const RaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      racers = debugRacers();
    }

    return MaterialApp(
      title: title,
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

enum RaceType { individual, group, mass }

class _RaceHomePageState extends State<RaceHomePage> {
  bool _raceStarted = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  RaceType _raceType = RaceType.individual;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void arrangeRacers() {
    List<Racer> stillRunning =
        List.from(racers.where((racer) => racer.isRunning));
    stillRunning.sort((a, b) => a.bibNumber.compareTo(b.bibNumber));
    List<Racer> finished = List.from(racers.where((racer) => !racer.isRunning));
    finished.sort((a, b) => a.bibNumber.compareTo(b.bibNumber));
    racers = stillRunning + finished;
  }

  List<Racer> stillRunning() {
    return List.from(racers.where((racer) => racer.isRunning));
  }

  FloatingActionButton racerStartStopButton(Racer racer) {
    switch (_raceType) {
      case RaceType.mass:
        {
          if (_stopwatch.isRunning) {
            return FloatingActionButton(
                tooltip: 'End Race',
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop_outlined),
                onPressed: () {
                  handleStartStop(racer);
                });
          } else {
            return FloatingActionButton(
                tooltip: 'Start Race',
                child: const Icon(Icons.play_arrow_outlined),
                onPressed: () {
                  handleStartStop(racer);
                });
          }
        }
        break;
      default:
        return FloatingActionButton(onPressed: () {});
        break;
    }
  }

  void handleStartStop([Racer? racer]) {
    switch (_raceType) {
      case RaceType.mass:
        {
          if (!_stopwatch.isRunning && !_raceStarted) {
            // Start the race
            _raceStarted = true;
            _stopwatch.start();
            racers.forEach((racer) {
              racer.hasStarted = true;
            });
            // Make sure we re-render the app frequently so that the stopwatch is updated.
            _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
              setState(() {});
            });
            // Re-render app now.
            setState(() {});
          } else if (_stopwatch.isRunning) {
            if (racer != null) {
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
        }
        break;
      case RaceType.group:
        {}
        break;
      case RaceType.individual:
        {}
        break;
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
              if (kDebugMode) {
                racers = debugRacers();
              } else {
                racers = [];
              }
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
              Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: CupertinoColors.lightBackgroundGray),
                  child: Text(formatTime(_stopwatch.elapsedMilliseconds),
                      style: const TextStyle(
                          fontSize: 42, fontWeight: FontWeight.bold))),
              _stopwatch.isRunning
                  ? FloatingActionButton(
                      tooltip: 'End Race',
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.stop_outlined),
                      onPressed: handleStartStop)
                  : FloatingActionButton(
                      tooltip: 'Start Race',
                      child: const Icon(Icons.play_arrow_outlined),
                      onPressed: handleStartStop),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  backgroundColor: _raceType == RaceType.individual
                      ? Colors.red
                      : Colors.blue,
                  tooltip: 'Individual Starts',
                  label: const Text('Individual'),
                  onPressed: () => setState(() {
                    if (!_raceStarted) {
                      _raceType = RaceType.individual;
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  backgroundColor:
                      _raceType == RaceType.group ? Colors.red : Colors.blue,
                  tooltip: 'Group Starts',
                  label: const Text('Group'),
                  onPressed: () => setState(() {
                    if (!_raceStarted) {
                      _raceType = RaceType.group;
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  backgroundColor:
                      _raceType == RaceType.mass ? Colors.red : Colors.blue,
                  tooltip: 'Mass Starts',
                  label: const Text('Mass'),
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
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(4.0),
                  color: racers[index].isRunning
                      ? (racers[index].group % 2 == 0
                          ? Colors.lightGreen
                          : Colors.green)
                      : (racers[index].group % 2 == 0
                          ? Colors.blueGrey
                          : Colors.grey),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
