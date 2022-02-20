import 'package:panic_button/providers/localization.dart';
import 'package:panic_button/providers/splash.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/providers/firebase.dart';
import 'package:panic_button/providers/location.dart';
import 'package:panic_button/providers/network.dart';
import 'package:panic_button/providers/videos.dart';

import 'container.dart' as c;

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => c.getIt<SplashProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<AuthProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NetworkProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<VideoProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocalizationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FirebaseProvider>()),
  Provider.value(value: const <String, dynamic>{})
];