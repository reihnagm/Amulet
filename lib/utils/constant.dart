import 'package:amulet/data/models/language/language.dart';

class AppConstants { 
  static const String baseUrl = 'http://cxid.xyz:3000';
  static const String baseUrlDisbursementDenom = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/denom';
  static const String baseUrlPpob = '$switchToBaseUrl/ppob/api/v1';
  static const String switchToBaseUrl = "https://apidev.cxid.xyz:8443";
  static const String baseUrlAmulet = 'https://api-amulet-dev.inovasi78.com';
  static const String baseUrlDisbursementBank = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/bank';
  static const String baseUrlDisbursementEmoney = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/emoney';
  static const String baseUrlDisbursement = 'https://pg-$switchTo.connexist.id/disbursement/api/v1';
  static const String baseUrlEcommerce = '$switchToBaseUrl/commerce-hog/api/v1';
  static const String baseUrlPaymentGroupChannels = 'https://pg-sandbox.connexist.id/payment/pub/v1/payment/groupedChannels';
  static const String baseUrlVa = 'https://pg-$switchTo.connexist.id/payment/pub/v1/payment/channels';
  static const String baseUrlPaymentBilling  = 'https://pg-$switchTo.connexist.id/payment/page/guidance';
  static const String baseUrlHelpPayment = 'https://pg-$switchTo.connexist.id/payment/help/howto';
  
  static const String switchTo = "sandbox";
  static const String baseUrlHelpInboxPayment = 'https://pg-$switchTo.connexist.id/payment/help/howto/trx';
  static const String firebaseKey = 'AAAANB2UrtA:APA91bHdznzjWQFRD1AyLX1I6W134vNKDpUe8uObH5LdJVMK62UQGm8G6KCVKciam0p6E_ZxtAYsSZQVZdx68-IOtM6hQEhrXfBNqgW_CxuPEtGT8MLF9XxWtwJsOXWqMP_sFaDvx5e1';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String xContextId = '504200410208';
  static const String theme = 'theme';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: 'assets/icons/indonesia.png', languageName: 'Indonesia', countryCode: 'ID', languageCode: 'id'),
    LanguageModel(imageUrl: 'assets/icons/us.png', languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}