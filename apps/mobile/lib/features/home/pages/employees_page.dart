import 'package:flutter/material.dart';
import 'package:mobile/core/color.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Employees Content Goes Here'),
      ),
    );
  }
}
