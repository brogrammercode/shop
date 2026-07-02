import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/core/color.dart';
import 'package:user/core/routes.dart';
import 'package:user/features/auth/auth.cubit.dart';
import 'package:user/features/auth/auth.state.dart';
import 'package:user/utils/error.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.loadUserInfo.status != current.loadUserInfo.status,
        listener: (context, state) {
          if (state.loadUserInfo.status == OperationStatus.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state.loadUserInfo.status == OperationStatus.error) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
        ),
      ),
    );
  }
}
