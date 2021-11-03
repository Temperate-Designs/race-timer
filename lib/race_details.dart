import 'package:flutter/material.dart';

class RaceDetailsWidget extends StatefulWidget {
  const RaceDetailsWidget({Key? key}) : super(key: key);

  @override
  _RaceDetailsWidgetState createState() => _RaceDetailsWidgetState();
}

class _RaceDetailsWidgetState extends State<RaceDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: const Text(
          'Race Details',
        ),
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              'https://picsum.photos/id/908/600/?blur',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0x00EEEEEE),
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          'Date: 26. october 2021',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 20,),
                        ),
                        Text(
                          '3 racers',
                          style: TextStyle(fontSize: 20,),
                        ),
                        Text(
                          'Individual Starts',
                          style: TextStyle(fontSize: 20,),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: const [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0x00F5F5F5),
                        child: ListTile(
                          title: Text(
                            'Racer Joe',
                            style: TextStyle(fontSize: 24,),
                          ),
                          subtitle: Text(
                            'Group 1, Bib: 0001',
                            style: TextStyle(fontSize: 18,),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF303030),
                            size: 20,
                          ),
                          tileColor: Color(0xFFF5F5F5),
                          dense: false,
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0x00F5F5F5),
                        child: ListTile(
                          title: Text(
                            'Racer Jill',
                            style: TextStyle(fontSize: 24,),
                          ),
                          subtitle: Text(
                            'Group 1, Bib: 0002',
                            style: TextStyle(fontSize: 18,),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF303030),
                            size: 20,
                          ),
                          tileColor: Color(0xFFF5F5F5),
                          dense: false,
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0x00F5F5F5),
                        child: ListTile(
                          title: Text(
                            'Racer Jane',
                            style: TextStyle(fontSize: 24,),
                          ),
                          subtitle: Text(
                            'Group 2, Bib: 0003',
                            style: TextStyle(fontSize: 18,),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF303030),
                            size: 20,
                          ),
                          tileColor: Color(0xFFF5F5F5),
                          dense: false,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
