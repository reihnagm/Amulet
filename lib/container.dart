import 'package:get_it/get_it.dart';
import 'package:panic_button/services/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panic_button/data/repository/auth/auth.dart';
import 'package:panic_button/data/repository/splash/splash.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/providers/localization.dart';
import 'package:panic_button/providers/splash.dart';
import 'package:panic_button/services/navigation.dart';
import 'package:panic_button/providers/firebase.dart';
import 'package:panic_button/providers/location.dart';
import 'package:panic_button/providers/network.dart';
import 'package:panic_button/providers/videos.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => NotificationService());

  getIt.registerLazySingleton(() => AuthRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => SplashRepo(sharedPreferences: getIt()));

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
    sharedPreferences: getIt()
  ));
  getIt.registerFactory(() => SplashProvider(sharedPreferences: getIt(), splashRepo: getIt()));
  getIt.registerFactory(() => FirebaseProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => LocationProvider(sharedPreferences: getIt()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}