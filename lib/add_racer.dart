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
  String name = "";
  int milliseconds = 0;
  bool isRunning = true;

  Racer(this.bibNumber, this.name);
}

class AddRacerPage extends StatelessWidget {
  final nameController = TextEditingController();
  final bibController = TextEditingController();

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
              if (bibNumber != null && bibNumber > 0) {
                racers.add(new Racer(bibNumber, name));
                Navigator.pop(context);
              } else {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                        title: const Text('Please enter a valid bib number'),
                        titlePadding: EdgeInsets.all(32)));
              }
            },
            tooltip: 'Save Racer',
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Racer's Name"),
              controller: nameController,
            ),
            Padding(padding: EdgeInsets.all(20)),
            TextField(
              decoration: const InputDecoration(hintText: 'Bib Number'),
              controller: bibController,
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }
}
