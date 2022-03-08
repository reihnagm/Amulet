import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/data/repository/splash/splash.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  final SharedPreferences sharedPreferences;
  SplashProvider({
    required this.splashRepo,
    required this.sharedPreferences
  });

  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);

  late List<String> _languageList;
  final int _languageIndex = 0;

  List<String> get languageList => _languageList;
  int get languageIndex => _languageIndex;

  Future<bool> initConfig() async {
    ByteData asset = await rootBundle.load("assets/sounds/alert.mp3");
    await pool.play(await pool.load(asset));
    _languageList = splashRepo.getLanguageList();
    Future.delayed(Duration.zero, () => notifyListeners());
    return Future.value(true);
  }
}
