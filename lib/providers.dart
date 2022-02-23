import 'package:amulet/providers/contact.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:amulet/providers/inbox.dart';
import 'package:amulet/providers/localization.dart';
import 'package:amulet/providers/splash.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/providers/firebase.dart';
import 'package:amulet/providers/location.dart';
import 'package:amulet/providers/network.dart';
import 'package:amulet/providers/videos.dart';

import 'container.dart' as c;

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => c.getIt<SplashProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ContactProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<AuthProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NetworkProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<VideoProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocalizationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FirebaseProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<InboxProvider>()),
  Provider.value(value: const <String, dynamic>{})
];