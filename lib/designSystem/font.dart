import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTextStyle {
  static TextStyle pretendardStyle(double size, double? height) => TextStyle(
        fontFamily: 'Pretendard',
        fontSize: size,
        height: height,
      );

  static TextStyle pretendardRegularStyle(double size, double? height) =>
      pretendardStyle(size, height).copyWith(
        fontWeight: FontWeight.w400,
      );

  static TextStyle pretendardSemiBoldStyle(double size, double? height) =>
      pretendardStyle(size, height).copyWith(
        fontWeight: FontWeight.w600,
      );

  static TextStyle pretendardBoldStyle(double size, double? height) =>
      pretendardStyle(size, height).copyWith(
        fontWeight: FontWeight.w800,
      );

  static final TextStyle bannerBold = pretendardBoldStyle(26.sp, 1.3.h);
  static final TextStyle bannerRegular = pretendardRegularStyle(16.sp, 1.3.h);
  static final TextStyle pageTitleBold = pretendardBoldStyle(38.sp, 1.3.h);
  static final TextStyle pageTitleSemiBold =
      pretendardSemiBoldStyle(30.sp, 1.3.h);
  static final TextStyle contentBold = pretendardBoldStyle(22.sp, 1.3.h);
  static final TextStyle contentRegular = pretendardRegularStyle(16.sp, 1.3.h);
}
