import 'package:panic_button/data/models/language/language.dart';

class AppConstants { 
  static const String baseUrl = 'http://cxid.xyz:3000';
  static const String baseUrlAmulet = 'https://api-amulet-dev.inovasi78.com';
  static const String firebaseKey = 'AAAA16oxfyo:APA91bGCIa2Fxu6HC2dW9IEvjlJsDaZr9inVUEoRIgTFbceAjen3rWkqw8f9FkrBPDDPlzVNBr3k_DwEIpLQau4cfneE6gzXmmkUud4VYGEBLqwRigvPBDrpC0O26LsYLdNsoHC5PB4h';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: 'assets/icons/indonesia.png', languageName: 'Indonesia', countryCode: 'ID', languageCode: 'id'),
    LanguageModel(imageUrl: 'assets/icons/us.png', languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}