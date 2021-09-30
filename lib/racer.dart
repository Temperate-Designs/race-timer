import 'dart:math';

class Racer {
  int bibNumber = -1;
  int group = 1;
  String name = "";
  int startMilliseconds = 0;
  int finalMilliseconds = 0;
  bool isRunning = true;
  bool hasStarted = false;

  final randomizer = Random();

  Racer(this.bibNumber, this.group, {this.name = ""});
}
