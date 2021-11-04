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
  final List<Race> races = [];
}

class Race {}
