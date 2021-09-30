import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'racer.dart';

List<Racer> racers = [];

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
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
              racers.add(Racer(bibNumber, groupNumber, name: name));
              Navigator.pop(context);
            },
            tooltip: 'Save Racer',
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Align(
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
                SizedBox(
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
    );
  }
}
