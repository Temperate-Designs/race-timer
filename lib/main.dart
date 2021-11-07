import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swn_race_timer/race_state_model.dart';
import 'swn_race_timer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => RaceStateModel(),
    child: const MaterialApp(
      home: SWNRaceTimer(),
    ),
  ));
}
