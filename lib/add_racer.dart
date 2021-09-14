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

  final randomizer = Random();

  Racer.withoutName(this.bibNumber, this.group) {
    this.name = firstNames[randomizer.nextInt(firstNames.length)].capitalize() +
        ' ' +
        lastNames[randomizer.nextInt(lastNames.length)].capitalize();
  }

  Racer(this.bibNumber, this.group, this.name);
}

int maxBibNumber() {
  int highestNumber = 0;
  for (var element in racers) {
    highestNumber = max(highestNumber, element.bibNumber);
  }
  return highestNumber;
}

int maxGroupNumber() {
  int highestNumber = 1;
  for (var element in racers) {
    highestNumber = max(highestNumber, element.group);
  }
  return highestNumber;
}

class AddRacerPage extends StatelessWidget {
  final nameController = TextEditingController();
  final bibController = TextEditingController();
  final groupController = TextEditingController();

  AddRacerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Racer'),
        actions: [
          FloatingActionButton.extended(
            label: const Text('Save'),
            onPressed: () {
              String name = nameController.text;
              int? bibNumber = int.tryParse(bibController.text);
              int? groupNumber = int.tryParse(groupController.text);
              if (groupNumber == null || groupNumber < 1) {
                groupNumber = maxGroupNumber();
              }
              if (bibNumber == null || bibNumber < 1) {
                bibNumber = maxBibNumber() + 1;
              }
              if (name.isEmpty) {
                racers.add(Racer.withoutName(bibNumber, groupNumber));
              } else {
                racers.add(Racer(bibNumber, groupNumber, name));
              }
              Navigator.pop(context);
            },
            tooltip: 'Save Racer',
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                children: [
                  const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Racer's Name"))),
                  Container(
                    width: 200.0,
                    child: TextField(
                      controller: nameController,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Bib Number"),
                      )),
                  TextField(
                    decoration: InputDecoration(
                        hintText: (maxBibNumber() + 1).toString()),
                    controller: bibController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              TableRow(children: [
                const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Group Number"),
                    )),
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
      ),
    );
  }
}
