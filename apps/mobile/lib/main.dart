import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/core/theme.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupDependencies();
  runApp(const MyApp());
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
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: "Ladyluck'em",
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
