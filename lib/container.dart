import 'package:amulet/providers/contact.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/data/repository/inbox/inbox.dart';
import 'package:amulet/providers/inbox.dart';
import 'package:amulet/services/notification.dart';
import 'package:amulet/data/repository/auth/auth.dart';
import 'package:amulet/data/repository/splash/splash.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/providers/localization.dart';
import 'package:amulet/providers/splash.dart';
import 'package:amulet/services/navigation.dart';
import 'package:amulet/providers/firebase.dart';
import 'package:amulet/providers/location.dart';
import 'package:amulet/providers/network.dart';
import 'package:amulet/providers/videos.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => NotificationService());

  getIt.registerLazySingleton(() => AuthRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => SplashRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => InboxRepo(sharedPreferences: getIt()));

  getIt.registerFactory(() => AuthProvider(
    authRepo: getIt(), 
    navigationService: getIt(), 
    sharedPreferences: getIt()
  ));

  getIt.registerFactory(() => NetworkProvider(sharedPreferences: getIt()));

  getIt.registerFactory(() => LocalizationProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => VideoProvider(
    authProvider: getIt(),
    locationProvider: getIt(),
    sharedPreferences: getIt(),
    notificationService: getIt()
  ));

  getIt.registerFactory(() => SplashProvider(
    sharedPreferences: getIt(), 
    splashRepo: getIt()
  ));

  getIt.registerFactory(() => ContactProvider(authRepo: getIt()));

  getIt.registerFactory(() => FirebaseProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => LocationProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => InboxProvider(
    authProvider: getIt(),
    sharedPreferences: getIt(),
    inboxRepo: getIt()
  ));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}