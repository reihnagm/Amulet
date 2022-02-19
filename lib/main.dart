import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:panic_button/views/screens/splash/splash.dart';
import 'package:panic_button/utils/global.dart';
import 'package:panic_button/providers.dart';
import 'package:panic_button/container.dart' as core;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await core.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Panic Button',
        navigatorKey: GlobalVariable.navState,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(key: UniqueKey()),
      ),
    );
  }
}