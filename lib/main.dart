import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:amulet/views/screens/history/history.dart';
import 'package:amulet/utils/constant.dart';
import 'package:amulet/views/screens/reports/index.dart';
import 'package:amulet/localization/app_localization.dart';
import 'package:amulet/providers/localization.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/utils/global.dart';
import 'package:amulet/providers/firebase.dart';
import 'package:amulet/services/notification.dart';
import 'package:amulet/providers.dart';
import 'package:amulet/container.dart' as core;
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
  
  void onClickedNotification(String? payload) {
    if(payload == "history") {
      GlobalVariable.navState.currentState!.pushAndRemoveUntil(
        PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return HistoryScreen(key: UniqueKey());
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
    } else {
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
  } 

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: 'Amulet',
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
      home: HomeScreen(key: UniqueKey()),
    );
  }
}