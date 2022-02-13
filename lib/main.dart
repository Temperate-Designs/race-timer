import 'package:flutter/material.dart';

void main() {
  runApp(const RaceTimer());
}

class Race {
  String title = '';
  String description = '';
  List<Racer> racers = [];
}

class Racer {
  String name = '';
}

class RaceTimer extends StatelessWidget {
  const RaceTimer({Key? key}) : super(key: key);

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
