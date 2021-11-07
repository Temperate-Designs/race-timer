import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RaceStateModel extends ChangeNotifier {
  late List<Race> _races = [];

  RaceStateModel() {
    if (kDebugMode) {
      _races = [
        Race(
          name: 'Kwage Trail Time Trial',
          date: DateTime.now(),
          type: RaceType.group,
          racers: [
            Racer(
              name: "Anthony Adams",
              bibNumber: 1,
              startTime: DateTime.parse('2021-11-07 12:00:00'),
              finishTime: DateTime.parse('2021-11-07 12:30:00'),
            ),
            Racer(name: "Bernadette Boon", bibNumber: 2,
              startTime: DateTime.parse('2021-11-07 12:00:00'),
              finishTime: DateTime.parse('2021-11-07 12:25:23'),),
            Racer(name: "Charlie Check", bibNumber: 3, groupNumber: 2,
              startTime: DateTime.parse('2021-11-07 12:10:00'),
              finishTime: DateTime.parse('2021-11-07 12:32:20'),),
          ],
        ),
        Race(
            name: 'Roundabout and back',
            date: DateTime.parse('2021-02-02 17:42'),
            type: RaceType.individual,
            racers: [
              Racer(name: "Jim Jimson", bibNumber: 1),
              Racer(name: "Fred Fredrikson", bibNumber: 2),
              Racer(name: "George Smith", bibNumber: 3, groupNumber: 2),
            ]),
        Race(
          name: 'Perimeter to cemetary',
          date: DateTime.parse('2021-03-03 12:33'),
        )
      ];
    }
  }

  int get numberOfRaces => _races.length;
  UnmodifiableListView<Race> get races => UnmodifiableListView(_races);

  @override
  bool operator ==(RaceStateModel) {
    // FIXME: Implement real comparison
    return true;
  }
}

class Race {
  String name;
  DateTime date;
  RaceType type;
  List<Racer> racers = [];

  Race(
      {required this.name,
      required this.date,
      this.racers = const [],
      this.type = RaceType.mass});

  void addRacer(Racer racer) {
    if (racers.where((r) => r.bibNumber == racer.bibNumber).isNotEmpty) {
      // FIXME: Open warning screen
    }
    racers.add(racer);
  }
}

class Racer {
  late String name;
  late int groupNumber;
  late int bibNumber;
  late DateTime? startTime;
  late DateTime? finishTime;

  Racer(
      {required name,
      required bibNumber,
      groupNumber = 1,
      this.startTime,
      this.finishTime}) {
    this.name = name;
    if (bibNumber > 0) {
      // FIXME: Open warning screen
    }
    this.bibNumber = bibNumber;
    if (groupNumber >= 1) {
      // FIXME: Open warning screen
    }
    this.groupNumber = groupNumber;
  }

  String time() {
    if (startTime == null) {
      return '-';
    }
    if (finishTime == null) {
      return '-';
    }
    return '${finishTime?.difference(startTime ?? DateTime.now())}';
  }
}

enum RaceType {
  individual,
  group,
  mass,
}

extension ParseToString on RaceType {
  // FIXME: Make this work
  String toRaceTypeString() {
    switch (this) {
      case RaceType.individual:
        return 'Individual';
      case RaceType.group:
        return 'Group';
      case RaceType.mass:
        return 'Mass';
      default:
        return 'Unknown';
    }
  }
}
