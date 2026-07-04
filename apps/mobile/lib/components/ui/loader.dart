import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';

class AppLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const AppLoader({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _colorAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.primaryGreen, end: AppColors.headerBlue)),
        TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.headerBlue, end: AppColors.gold)),
        TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.gold, end: AppColors.districtPurple)),
        TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.districtPurple, end: AppColors.primaryGreen)),
      ],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.w,
      width: widget.size.w,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return CircularProgressIndicator(
            strokeWidth: widget.strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
          );
        },
      ),
    );
  }
}
