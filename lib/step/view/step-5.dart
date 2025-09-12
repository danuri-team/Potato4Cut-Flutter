import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Step5Page extends StatelessWidget {
  const Step5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 52.w,
          vertical: 58.h,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset('assets/images/icons/close.svg'),
            ),
            SizedBox(height: 174.h),
            Text(
              '출력중입니다',
              style: TextStyle(
                fontSize: 38.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 47.h),
            Text(
              '15~20초 정도 소요됩니다',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            SvgPicture.asset('assets/images/icons/waiting_potato.svg'),
          ],
        ),
      ),
    );
  }
}
