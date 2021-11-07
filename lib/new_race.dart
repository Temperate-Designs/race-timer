import 'package:flutter/material.dart';
import 'package:swn_race_timer/edit_racer.dart';
import 'package:swn_race_timer/race.dart';

class NewRaceWidget extends StatefulWidget {
  const NewRaceWidget({Key? key}) : super(key: key);

  @override
  _NewRaceWidgetState createState() => _NewRaceWidgetState();
}

class _NewRaceWidgetState extends State<NewRaceWidget> {
  TextEditingController? textController;
  bool? switchListTileValue1;
  bool? switchListTileValue2;
  bool? switchListTileValue3;
  bool _loadingButton1 = false;
  bool _loadingButton2 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: const Text(
          'New Race',
          style: TextStyle(fontSize: 24,),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFF5F5F5),
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
          'New Racer',
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
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0x80EEEEEE),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Text(
                            'Race Name',
                            style: TextStyle(fontSize: 16,),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: textController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Please enter the race name',
                              hintStyle: TextStyle(fontSize: 16,),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style: TextStyle(fontSize: 16,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0x80EEEEEE),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Text(
                            'Race Type',
                            style: TextStyle(fontSize: 16,),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 200,
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: SwitchListTile(
                                  value: switchListTileValue1 ??= true,
                                  onChanged: (newValue) => setState(
                                      () => switchListTileValue1 = newValue),
                                  title: Text(
                                    'Individual',
                                    style: TextStyle(fontSize: 16,),
                                  ),
                                  tileColor: Color(0xFFF5F5F5),
                                  dense: false,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: SwitchListTile(
                                  value: switchListTileValue2 ??= true,
                                  onChanged: (newValue) => setState(
                                      () => switchListTileValue2 = newValue),
                                  title: Text(
                                    'Group',
                                    style: TextStyle(fontSize: 16,),
                                  ),
                                  tileColor: Color(0xFFF5F5F5),
                                  dense: false,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: SwitchListTile(
                                  value: switchListTileValue3 ??= true,
                                  onChanged: (newValue) => setState(
                                      () => switchListTileValue3 = newValue),
                                  title: Text(
                                    'Mass',
                                    style: TextStyle(fontSize: 16,),
                                  ),
                                  tileColor: Color(0xFFF5F5F5),
                                  dense: false,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 4),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0x00EEEEEE),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                            child: TextButton(
                              onPressed: () async {
                                setState(() => _loadingButton1 = true);
                                try {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RaceWidget(),
                                    ),
                                  );
                                } finally {
                                  setState(() => _loadingButton1 = false);
                                }
                              },
                              child: Text('Done'),                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                            child: TextButton(
                              onPressed: () async {
                                setState(() => _loadingButton2 = true);
                                try {
                                  Navigator.pop(context);
                                } finally {
                                  setState(() => _loadingButton2 = false);
                                }
                              },
                              child: Text('Cancel'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0x00F5F5F5),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRacerWidget(),
                                ),
                              );
                            },
                            child: const ListTile(
                              title: Text(
                                'Racer Joe',
                              ),
                              subtitle: Text(
                                'Group 1, Bib: 0001',
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
                          color: const Color(0x00F5F5F5),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRacerWidget(),
                                ),
                              );
                            },
                            child: const ListTile(
                              title: Text(
                                'Racer Jill',
                              ),
                              subtitle: Text(
                                'Group 1, Bib: 0002',
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
