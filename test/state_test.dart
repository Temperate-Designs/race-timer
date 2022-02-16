import 'package:swn_race_timer/main.dart';
import 'package:test/test.dart';

void main() {
  test('Data class tests', () {
    Racer racer = Racer(name: 'Name', bibNumber: 1);
    expect(racer.name, 'Name');
    expect(racer.bibNumber, 1);
  });
}
