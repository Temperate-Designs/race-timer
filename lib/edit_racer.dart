import 'package:flutter/material.dart';

class EditRacerWidget extends StatefulWidget {
  const EditRacerWidget({Key? key}) : super(key: key);

  @override
  _EditRacerWidgetState createState() => _EditRacerWidgetState();
}

class _EditRacerWidgetState extends State<EditRacerWidget> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  TextEditingController? textController3;
  bool _loadingButton1 = false;
  bool _loadingButton2 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: const Text(
          'Edit Racer',
          style: TextStyle(
            fontSize: 20,
          ),
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
                    color: Color(0x80EEEEEE),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: textController1,
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: '[Some hint text...]',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0x80EEAAAA),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: Text(
                          'Group',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: textController2,
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: '[Some hint text...]',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0x80EEEEEE),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: Text(
                          'Bib Nr.',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: textController3,
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: '[Some hint text...]',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0x00EEEEEE),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: TextButton.icon(
                          onPressed: () async {
                            setState(() => _loadingButton1 = true);
                            try {
                              Navigator.pop(context);
                            } finally {
                              setState(() => _loadingButton1 = false);
                            }
                          },
                          label: const Text('Save'),
                          icon: const Icon(
                            Icons.save,
                            size: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: TextButton.icon(
                          onPressed: () async {
                            setState(() => _loadingButton2 = true);
                            try {
                              Navigator.pop(context);
                            } finally {
                              setState(() => _loadingButton2 = false);
                            }
                          },
                          label: const Text('Cancel'),
                          icon: const Icon(
                            Icons.cancel,
                            size: 15,
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
