import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/controllers/user.cubit.dart';
import 'package:mobile/features/auth/controllers/user.state.dart';
import 'package:mobile/services/json_cache.dart';
import 'package:mobile/features/business/models/business_context.dart';
import 'package:mobile/core/routes.dart';

import 'package:mobile/utils/error.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  BusinessContextModel? _context;

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    final cache = JsonCache();
    final data = await cache.getBusinessContext();
    if (data != null) {
      setState(() {
        _context = BusinessContextModel.fromJson(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocListener<UserCubit, UserState>(
        listenWhen: (previous, current) => previous.logoutInfo != current.logoutInfo,
        listener: (context, state) {
          if (state.logoutInfo.status == OperationStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: Center(
          child: _context == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Branch: ${_context!.branch.name}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('Employee: ${_context!.employee.name}'),
                    const SizedBox(height: 10),
                    Text('Role: ${_context!.employee.role_id}'),
                  ],
                ),
        ),
      ),
    );
  }
}
