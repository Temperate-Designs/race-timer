import 'package:flutter/material.dart';

void main() {
  runApp(RaceApp());
}

class RaceApp extends StatelessWidget {
  final title = 'SWN Race Timer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RaceHomePage(title: title),
    );
  }
}

class RaceHomePage extends StatefulWidget {
  RaceHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _RaceHomePageState createState() => _RaceHomePageState();
}

class _RaceHomePageState extends State<RaceHomePage> {
  List<int> bibNumbers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(6.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Text('Racers')),
          Expanded(
            child: ListView.builder(
              itemCount: bibNumbers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(
                    child: Text(index.toString().padLeft(4, '0')),
                  ),
                );
              },
            ),
          )
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            bibNumbers.add(bibNumbers.length + 1);
          });
        },
        tooltip: 'Add Racer',
        label: Text('Add Racer'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
