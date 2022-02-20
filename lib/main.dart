import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/utils/constant.dart';
import 'package:panic_button/localization/app_localization.dart';
import 'package:panic_button/providers/localization.dart';
import 'package:panic_button/views/screens/splash/splash.dart';
import 'package:panic_button/utils/global.dart';
import 'package:panic_button/providers.dart';
import 'package:panic_button/container.dart' as core;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await core.init();
  runApp(MultiProvider(
    providers: providers,
    child: MyApp(key: UniqueKey())
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: 'Panic Button',
      debugShowCheckedModeBanner: false,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      navigatorKey: GlobalVariable.navState,
      home: SplashScreen(key: UniqueKey()),
    );
  }
}