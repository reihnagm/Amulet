import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String formatCurrency(double number) {
    final NumberFormat _fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    String s = _fmt.format(number);
    String _format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return _format;
  }

  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }

  static Future<String> downloadFile(String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static SharedPreferences? prefs;
  static Future initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}