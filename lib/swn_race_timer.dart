import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:swn_race_timer/edit_racer.dart';
import 'package:swn_race_timer/race_details.dart';

class SWNRaceTimer extends StatefulWidget {
  const SWNRaceTimer({Key? key}) : super(key: key);

  @override
  _SWNRaceTimerState createState() => _SWNRaceTimerState();
}

class _SWNRaceTimerState extends State<SWNRaceTimer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.blue),
        automaticallyImplyLeading: true,
        title: const Text(
          'SWN Race Timer',
          style: TextStyle(fontSize: 24),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditRacerWidget(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        icon: const Icon(
          Icons.add,
        ),
        elevation: 8,
        label: const Text(
          'New Race',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
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
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: Text(
                    'Past Races',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0x80F5F5F5),
                        elevation: 2,
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RaceDetailsWidget(),
                              ),
                            );
                          },
                          child: Slidable(
                            actionPane: const SlidableScrollActionPane(),
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.blue,
                                icon: Icons.delete,
                                onTap: () {
                                  print('SlidableActionWidget pressed ...');
                                },
                              ),
                              IconSlideAction(
                                caption: 'Share',
                                color: Colors.blue,
                                icon: Icons.share,
                                onTap: () {
                                  print('SlidableActionWidget pressed ...');
                                },
                              )
                            ],
                            child: const ListTile(
                              title: Text(
                                'Kwage Trail Time Trials',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                '22. October 2021',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
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
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0x80F5F5F5),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RaceDetailsWidget(),
                              ),
                            );
                          },
                          child: const ListTile(
                            title: Text(
                              'Kwage Trail Time Trials',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              '22. October 2021',
                              style: TextStyle(
                                fontSize: 20,
                              ),
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
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0x80F5F5F5),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RaceDetailsWidget(),
                              ),
                            );
                          },
                          child: const ListTile(
                            title: Text(
                              'Kwage Trail Time Trials',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              '22. October 2021',
                              style: TextStyle(
                                fontSize: 16,
                              ),
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
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0x80F5F5F5),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RaceDetailsWidget(),
                              ),
                            );
                          },
                          child: const ListTile(
                            title: Text(
                              'Kwage Trail Time Trials',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              '22. October 2021',
                              style: TextStyle(
                                fontSize: 16,
                              ),
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
