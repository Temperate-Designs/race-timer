import 'package:flutter/material.dart';

class RaceWidget extends StatefulWidget {
  const RaceWidget({Key? key}) : super(key: key);

  @override
  _RaceWidgetState createState() => _RaceWidgetState();
}

class _RaceWidgetState extends State<RaceWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
