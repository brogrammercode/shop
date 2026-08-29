import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/core/theme.dart';
import 'package:mobile/features/notification/firebase_messaging.service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await dotenv.load(fileName: ".env");
  await setupDependencies();
  runApp(const MyApp());
  await FirebaseMessagingNavigationService.configure();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppDependencies.coreHrCubit()),
        BlocProvider(create: (_) => AppDependencies.inventoryCubit()),
        BlocProvider(create: (_) => AppDependencies.catalogCubit()),
        BlocProvider(create: (_) => AppDependencies.posKdsCubit()),
        BlocProvider(create: (_) => AppDependencies.manufacturingCubit()),
        BlocProvider(create: (_) => AppDependencies.financeCubit()),
        BlocProvider(create: (_) => AppDependencies.crmCubit()),
        BlocProvider(create: (_) => AppDependencies.notificationCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: "L'em",
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            builder: (context, child) {
              return Container(
                color: AppColors.pureWhite, // keep it light only
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
