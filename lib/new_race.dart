import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swn_race_timer/edit_racer.dart';
import 'package:swn_race_timer/race.dart';
import 'package:swn_race_timer/race_state_model.dart';

class NewRaceWidget extends StatefulWidget {
  const NewRaceWidget({Key? key}) : super(key: key);

  @override
  _NewRaceWidgetState createState() => _NewRaceWidgetState();
}

class _NewRaceWidgetState extends State<NewRaceWidget> {
  late TextEditingController nameTextController;
  bool switchIndividual = true;
  bool switchGroup = false;
  bool switchMass = false;
  bool _saveRaceButton = false;
  bool _cancelNewRaceButton = false;
  Race newRace = Race();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const AdRequest request = AdRequest();
  BannerAd? _ad;
  bool _isAdLoaded = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      log('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-4328959315579213/8369004752',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$BannerAd loaded.');
          setState(() {
            _ad = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController();
    if (kDebugMode) {
      newRace.name = "Testrace";
      nameTextController.text = newRace.name;
      newRace.addRacer(Racer(
        name: "Jim",
        bibNumber: 1,
        groupNumber: 1,
      ));
      newRace.addRacer(Racer(
        name: "Bob",
        bibNumber: 2,
        groupNumber: 1,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _ad?.dispose();
    nameTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      _isAdLoaded = true;
      _createAnchoredBanner(context);
    }
    return Consumer<RaceStateModel>(
      builder: (context, model, child) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: true,
            title: const Text(
              'New Race',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 4,
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final racer = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRacerWidget(
                      bibNumberHint: newRace.lastBibNumber() + 1,
                      groupNumberHint: newRace.lastGroupNumber() == 0
                          ? 1
                          : newRace.lastGroupNumber()),
                ),
              );
              if (racer != null) {
                newRace.addRacer(racer);
              }
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
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Image.asset(
                    'assets/images/background.jpg',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (_ad != null)
                        Container(
                          child: AdWidget(ad: _ad!),
                          width: _ad!.size.width.toDouble(),
                          height: _ad!.size.height.toDouble(),
                          alignment: Alignment.center,
                        ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Color(0xD0FFFFFF),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                              child: Text(
                                'Race Name',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: nameTextController,
                                obscureText: false,
                                decoration: const InputDecoration(
                                  hintText: 'Please enter the race name',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                          color: Color(0xD0FFFFFF),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                              child: Text(
                                'Race Type',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 0),
                                    child: SwitchListTile(
                                      value: switchIndividual,
                                      onChanged: (newValue) {
                                        switchIndividual = newValue;
                                        if (switchIndividual) {
                                          setState(() {
                                            switchGroup = false;
                                            switchMass = false;
                                          });
                                        }
                                      },
                                      title: const Text(
                                        'Individual',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      tileColor: const Color(0xFFF5F5F5),
                                      dense: false,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 0),
                                    child: SwitchListTile(
                                      value: switchGroup,
                                      onChanged: (newValue) {
                                        switchGroup = newValue;
                                        if (switchGroup) {
                                          setState(() {
                                            switchIndividual = false;
                                            switchMass = false;
                                          });
                                        }
                                      },
                                      title: const Text(
                                        'Group',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      tileColor: const Color(0xFFF5F5F5),
                                      dense: false,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 0),
                                    child: SwitchListTile(
                                      value: switchMass,
                                      onChanged: (newValue) {
                                        switchMass = newValue;
                                        if (switchMass) {
                                          setState(() {
                                            switchIndividual = false;
                                            switchGroup = false;
                                          });
                                        }
                                      },
                                      title: const Text(
                                        'Mass',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      tileColor: const Color(0xFFF5F5F5),
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 4),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Color(0xD0FFFFFF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 0, 4, 0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () async {
                                    setState(() => _saveRaceButton = true);
                                    if (nameTextController.text.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                  'The race name cannot be empty'),
                                            );
                                          });
                                    } else {
                                      newRace.name = nameTextController.text;
                                      if (switchIndividual) {
                                        newRace.type = RaceType.individual;
                                      } else if (switchGroup) {
                                        newRace.type = RaceType.group;
                                      } else if (switchMass) {
                                        newRace.type = RaceType.mass;
                                      }
                                      model.addRace(newRace);
                                      try {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RaceWidget(newRace),
                                          ),
                                        );
                                      } finally {
                                        setState(() => _saveRaceButton = false);
                                      }
                                    }
                                  },
                                  child: const Text('Done'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 0, 4, 0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    setState(() => _cancelNewRaceButton = true);
                                    try {
                                      Navigator.pop(context);
                                    } finally {
                                      setState(
                                          () => _cancelNewRaceButton = false);
                                    }
                                  },
                                  child: const Text('Cancel'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: newRace.racers.length,
                          itemBuilder: (context, index) => Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: const Color(0x00F5F5F5),
                            child: InkWell(
                              onTap: () async {
                                Racer? racer = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditRacerWidget(
                                          racer: newRace.racers[index])),
                                );
                                if (racer != null) {
                                  newRace.racers[index] = racer;
                                }
                              },
                              child: ListTile(
                                title: Text(newRace.racers[index].name),
                                subtitle: Text(
                                  'Group ${newRace.racers[index].groupNumber}, Bib: ${newRace.racers[index].bibNumber}',
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF303030),
                                  size: 20,
                                ),
                                tileColor: const Color(0xFFF5F5F5),
                                dense: false,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
