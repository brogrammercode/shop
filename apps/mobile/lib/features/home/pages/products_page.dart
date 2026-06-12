import 'package:flutter/material.dart';
import 'package:mobile/core/color.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Products Content Goes Here'),
      ),
    );
  }
}
