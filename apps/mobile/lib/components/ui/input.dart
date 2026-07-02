import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';

class AppInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final FocusNode? focusNode;
  final String? initialValue;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppInput({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.inputFormatters,
    this.enabled = true,
    this.focusNode,
    this.initialValue,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMultiLine = maxLines > 1;

    return Container(
      constraints: isMultiLine ? null : BoxConstraints(minHeight: 42.h),
      decoration: BoxDecoration(
        color: enabled ? AppColors.pureWhite : AppColors.softGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Focus(
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: enabled ? AppColors.pureWhite : AppColors.softGrey,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: hasFocus ? AppColors.primaryGreen : AppColors.softGrey,
                  width: 1.5.w,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: isMultiLine ? 10.h : 0,
              ),
              child: Row(
                crossAxisAlignment: isMultiLine
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      initialValue: initialValue,
                      obscureText: obscureText,
                      keyboardType: keyboardType,
                      onChanged: onChanged,
                      validator: validator,
                      maxLines: maxLines,
                      inputFormatters: inputFormatters,
                      enabled: enabled,
                      focusNode: focusNode,
                      onTap: onTap,
                      readOnly: readOnly,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: isMultiLine
                            ? EdgeInsets.zero
                            : EdgeInsets.symmetric(vertical: 11.h),
                      ),
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    SizedBox(width: 8.w),
                    suffixIcon!,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
