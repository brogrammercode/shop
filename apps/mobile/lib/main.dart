import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/core/theme.dart';
import 'package:mobile/features/auth/controllers/user.cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.42857142857144, 843.4285714285714),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<UserCubit>(
              create: (context) => AppDependencies.userCubit,
            ),
          ],
          child: MaterialApp(
            title: 'User Shop App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.session,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}

