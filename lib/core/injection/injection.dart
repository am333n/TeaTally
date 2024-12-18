import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:teatally/core/injection/injection.config.dart';
import 'package:teatally/core/router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';

final getIt = GetIt.instance;
@InjectableInit()
void configureDependencies() {
  getIt.init();
  GetIt.I.registerSingleton<GlobalKey<ScaffoldMessengerState>>(
      GlobalKey<ScaffoldMessengerState>());
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}