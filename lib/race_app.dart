import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import "add_racer.dart";

class RaceApp extends StatelessWidget {
  final title = 'SWN Race Timer';

  @override
  Widget build(BuildContext context) {
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
  RaceHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _RaceHomePageState createState() => _RaceHomePageState();
}

class _RaceHomePageState extends State<RaceHomePage> {
  Stopwatch _stopwatch = new Stopwatch();
  Timer? _timer;

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

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      setState(() {});
    } else {
      if (stillRunning().length > 0) {
        _stopwatch.start();
        _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
          setState(() {});
        });
        setState(() {}); // re-render the page
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
            icon: Icon(Icons.clear),
            onPressed: () {
              racers = [];
              _stopwatch = new Stopwatch();
              _timer?.cancel();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
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
                  decoration:
                      BoxDecoration(color: CupertinoColors.lightBackgroundGray),
                  child: Text(formatTime(_stopwatch.elapsedMilliseconds),
                      style: TextStyle(
                          fontSize: 42, fontWeight: FontWeight.bold))),
              _stopwatch.isRunning
                  ? FloatingActionButton(
                      tooltip: 'End Race',
                      backgroundColor: Colors.red,
                      child: Icon(Icons.stop_outlined),
                      onPressed: handleStartStop)
                  : FloatingActionButton(
                      tooltip: 'Start Race',
                      child: Icon(Icons.play_arrow_outlined),
                      onPressed: handleStartStop),
            ],
          ),
          Container(
              margin: const EdgeInsets.all(6.0),
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  border: Border.all(color: Colors.blueAccent)),
              child: Text('Racers',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
          Divider(thickness: 2),
          Expanded(
            child: ListView.builder(
              itemCount: racers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                              'Bib: ${racers[index].bibNumber.toString().padLeft(4, '0')}',
                              style: TextStyle(fontSize: 20)),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20)),
                          Text(
                              formatTime(racers[index].isRunning
                                  ? _stopwatch.elapsedMilliseconds
                                  : racers[index].milliseconds),
                              style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      Row(children: [
                        Text(
                            'Group: ${racers[index].group.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 20)),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        Text(racers[index].name, style: TextStyle(fontSize: 20))
                      ]),
                    ],
                  ),
                  onTap: () {
                    if (racers[index].isRunning && _stopwatch.isRunning) {
                      racers[index].isRunning = false;
                      racers[index].milliseconds =
                          _stopwatch.elapsedMilliseconds;
                      arrangeRacers();
                    }
                    if (stillRunning().length == 0) {
                      handleStartStop();
                    }
                  },
                  dense: true,
                  tileColor: racers[index].isRunning
                      ? Colors.lightGreen
                      : Colors.blueGrey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
