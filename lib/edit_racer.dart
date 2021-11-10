import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swn_race_timer/race_state_model.dart';

class EditRacerWidget extends StatefulWidget {
  final int bibNumberHint;
  final int groupNumberHint;
  final Racer? racer;

  const EditRacerWidget(
      {Key? key, this.bibNumberHint = 1, this.groupNumberHint = 1, this.racer})
      : super(key: key);

  @override
  _EditRacerWidgetState createState() => _EditRacerWidgetState();
}

class _EditRacerWidgetState extends State<EditRacerWidget> {
  Racer racer = Racer(
    name: 'unset',
    bibNumber: 1,
    groupNumber: 1,
  );
  late TextEditingController racerNameTextController;
  late TextEditingController bibNumberTextController;
  late TextEditingController groupNumberTextController;
  bool _loadingButton1 = false;
  bool _loadingButton2 = false;
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
  void dispose() {
    super.dispose();
    _ad?.dispose();
  }

  @override
  void initState() {
    super.initState();
    racerNameTextController = TextEditingController();
    bibNumberTextController = TextEditingController();
    groupNumberTextController = TextEditingController();
    if (widget.racer != null) {
      racer = widget.racer!;
      racerNameTextController.text = racer.name;
      bibNumberTextController.text = racer.bibNumber.toString();
      groupNumberTextController.text = racer.groupNumber.toString();
    }
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
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Image.asset(
                    'assets/images/background.jpg',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
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
                              controller: racerNameTextController,
                              obscureText: false,
                              decoration: const InputDecoration(
                                hintText: 'Racer Name',
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
                              'Bib Number',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: bibNumberTextController,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: '${widget.bibNumberHint}',
                                hintStyle: const TextStyle(
                                  fontSize: 20,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
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
                              'Group',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: groupNumberTextController,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: '${widget.groupNumberHint}',
                                hintStyle: const TextStyle(
                                  fontSize: 20,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 8, 8, 8),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                setState(() => _loadingButton1 = true);
                                if (racerNameTextController.text.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                              'The racer name cannot be empty'),
                                        );
                                      });
                                  return;
                                }

                                if (bibNumberTextController.text.isEmpty) {
                                  bibNumberTextController.text =
                                      '${widget.bibNumberHint}';
                                }

                                if (groupNumberTextController.text.isEmpty) {
                                  groupNumberTextController.text =
                                      '${widget.groupNumberHint}';
                                }

                                Racer racer = Racer(
                                    name: racerNameTextController.text,
                                    bibNumber:
                                        int.parse(bibNumberTextController.text),
                                    groupNumber: int.parse(
                                        groupNumberTextController.text));
                                try {
                                  Navigator.pop(context, racer);
                                } finally {
                                  setState(() => _loadingButton1 = false);
                                }
                              },
                              // FIXME: Fix button background.
                              label: const Text('Save'),
                              icon: const Icon(
                                Icons.save,
                                size: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 8, 8, 8),
                            child: ElevatedButton.icon(
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
      },
    );
  }
}
