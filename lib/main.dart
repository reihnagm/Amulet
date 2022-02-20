import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:panic_button/views/screens/media/record.dart';
import 'package:panic_button/views/screens/reports/index.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/utils/constant.dart';
import 'package:panic_button/localization/app_localization.dart';
import 'package:panic_button/providers/localization.dart';
import 'package:panic_button/views/screens/splash/splash.dart';
import 'package:panic_button/utils/global.dart';
import 'package:panic_button/providers/firebase.dart';
import 'package:panic_button/services/notification.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseProvider firebaseProvider;

  @override 
  void initState() {
    super.initState();

    firebaseProvider = context.read<FirebaseProvider>();

    Future.delayed(Duration.zero, () async {
      await firebaseProvider.init();
      await NotificationService.init();
      await firebaseProvider.setupInteractedMessage(context);
    });
    firebaseProvider.listenNotification(context);
    listenOnClickNotifications();
  }

  void listenOnClickNotifications() => NotificationService.onNotifications.stream.listen(onClickedNotification);
  
  void onClickedNotification(String? payload) async {
    GlobalVariable.navState.currentState!.pushAndRemoveUntil(
      PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return ReportsScreen(key: UniqueKey());
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }),
      (Route<dynamic> route) => route.isFirst
    );
  }

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