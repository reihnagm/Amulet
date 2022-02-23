import 'package:amulet/data/models/language/language.dart';

class AppConstants { 
  static const String baseUrl = 'http://cxid.xyz:3000';
  static const String baseUrlAmulet = 'https://api-amulet-dev.inovasi78.com';
  static const String firebaseKey = 'AAAANB2UrtA:APA91bHdznzjWQFRD1AyLX1I6W134vNKDpUe8uObH5LdJVMK62UQGm8G6KCVKciam0p6E_ZxtAYsSZQVZdx68-IOtM6hQEhrXfBNqgW_CxuPEtGT8MLF9XxWtwJsOXWqMP_sFaDvx5e1';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: 'assets/icons/indonesia.png', languageName: 'Indonesia', countryCode: 'ID', languageCode: 'id'),
    LanguageModel(imageUrl: 'assets/icons/us.png', languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}