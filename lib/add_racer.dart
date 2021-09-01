import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<String> firstNames = [
  'good',
  'new',
  'first',
  'last',
  'long',
  'great',
  'little',
  'own',
  'other',
  'old',
  'right',
  'big',
  'high',
  'different',
  'small',
  'large',
  'next',
  'early',
  'young',
  'important',
  'few',
  'public',
  'bad',
  'same',
  'able',
];

const List<String> lastNames = [
  'time',
  'person',
  'year',
  'way',
  'day',
  'thing',
  'man',
  'world',
  'life',
  'hand',
  'part',
  'child',
  'eye',
  'woman',
  'place',
  'work',
  'week',
  'case',
  'point',
  'government',
  'company',
  'number',
  'group',
  'problem',
  'fact',
];

List<Racer> racers = [];

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class Racer {
  int bibNumber = -1;
  int group = 1;
  String name = "";
  int milliseconds = 0;
  bool isRunning = true;

  Racer(this.bibNumber, this.group, this.name);
}

int maxBibNumber() {
  int highestNumber = 0;
  racers.forEach((element) {
    highestNumber = max(highestNumber, element.bibNumber);
  });
  return highestNumber;
}

int maxGroupNumber() {
  int highestNumber = 1;
  racers.forEach((element) {
    highestNumber = max(highestNumber, element.group);
  });
  return highestNumber;
}

class AddRacerPage extends StatelessWidget {
  final nameController = TextEditingController();
  final bibController = TextEditingController();
  final groupController = TextEditingController();

  final randomizer = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Racer'),
        actions: [
          FloatingActionButton.extended(
            label: Text('Save'),
            onPressed: () {
              String name = nameController.text;
              if (name.isEmpty) {
                name = firstNames[randomizer.nextInt(firstNames.length)]
                        .capitalize() +
                    ' ' +
                    lastNames[randomizer.nextInt(lastNames.length)]
                        .capitalize();
              }
              int? bibNumber = int.tryParse(bibController.text);
              int? groupNumber = int.tryParse(groupController.text);
              if (groupNumber == null || groupNumber < 1) {
                groupNumber = maxGroupNumber();
              }
              if (bibNumber == null || bibNumber < 1) {
                bibNumber = maxBibNumber() + 1;
              }

              racers.add(new Racer(bibNumber, groupNumber, name));
              Navigator.pop(context);
            },
            tooltip: 'Save Racer',
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        child: Table(
          defaultColumnWidth: IntrinsicColumnWidth(),
          children: [
            TableRow(
              children: [
                const Text("Racer's Name"),
                TextField(
                  controller: nameController,
                ),
              ],
            ),
            TableRow(
              children: [
                const Text("Bib Number"),
                TextField(
                  decoration: InputDecoration(
                      hintText: (maxBibNumber() + 1).toString()),
                  controller: bibController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            TableRow(children: [
              const Text("Group Number"),
              TextField(
                decoration:
                    InputDecoration(hintText: maxGroupNumber().toString()),
                controller: groupController,
                keyboardType: TextInputType.number,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
