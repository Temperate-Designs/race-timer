import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RaceGlobalState extends InheritedWidget {
  final RaceGlobalStateData data;

  const RaceGlobalState({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static RaceGlobalState of(BuildContext context) {
    final RaceGlobalState? result =
        context.dependOnInheritedWidgetOfExactType<RaceGlobalState>();
    assert(result != null, 'No RaceGlobalState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RaceGlobalState oldWidget) {
    return data != oldWidget.data;
  }
}

class RaceGlobalStateData {
  late final List<Race> races;

  RaceGlobalStateData() {
    if (kDebugMode) {
      races = [
        Race(
          name: 'Kwage Trail Time Trial',
          date: DateTime.now(),
        ),
        Race(
          name: 'Raoundabout and back',
          date: DateTime.parse('2021-02-02 17:42'),
        ),
        Race(
          name: 'Perimeter to cemetary',
          date: DateTime.parse('2021-03-03 12:33'),
        )
      ];
    } else {
      races = [];
    }
  }
}

class Race {
  String name;
  DateTime date;

  Race({required this.name, required this.date});
}
