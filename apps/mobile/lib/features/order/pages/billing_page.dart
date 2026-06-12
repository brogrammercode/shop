import 'package:flutter/material.dart';
import 'package:mobile/core/color.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        title: const Text('Billing'),
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Billing Content Goes Here'),
      ),
    );
  }
}
