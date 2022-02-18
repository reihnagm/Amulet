import 'package:get_it/get_it.dart';
import 'package:panic_button/data/repository/auth/auth.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/services/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:panic_button/providers/firebase.dart';
import 'package:panic_button/providers/location.dart';
import 'package:panic_button/providers/network.dart';
import 'package:panic_button/providers/videos.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => AuthRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => NavigationService());

  getIt.registerFactory(() => AuthProvider(authRepo: getIt(), sharedPreferences: getIt()));
  getIt.registerFactory(() => NetworkProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => VideoProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => FirebaseProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => LocationProvider(sharedPreferences: getIt()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}