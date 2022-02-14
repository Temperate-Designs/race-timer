import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWN Race Timer',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Southwest Nordic Race Timer'),
        ),
        body: const Center(
          child: Text('Welcome'),
        ),
      ),
    );
  }
}
