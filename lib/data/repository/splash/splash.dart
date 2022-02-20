import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences});

 
  List<String> getLanguageList() {
    List<String> languageList = ['English', 'Indonesia'];
    return languageList;
  }
}