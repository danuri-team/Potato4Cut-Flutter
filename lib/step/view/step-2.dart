import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Step2Page extends StatelessWidget {
  const Step2Page({super.key});

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
            SizedBox(height: 10.h),
            Text(
              '사진에 QR을 첨부할까요?',
              style: TextStyle(
                fontSize: 38.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 46.h),
            Container(
              width: double.infinity,
              height: 480.h,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  SizedBox(
                    width: 270.w,
                    height: 480.h,
                    child: SvgPicture.asset(
                      'assets/images/icons/default_frame.svg',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 30.h,
                      right: 18.w,
                    ),
                    width: 270.w,
                    height: 480.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/icons/qr_example.png'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 300.h),
                      Row(
                        children: [
                          SizedBox(width: 254.w),
                          SvgPicture.asset('assets/images/icons/qr_curve.svg'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(),
                      const Text('모바일로 스캔하여 사진을 저장할 수 있어요'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 34.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 120.w,
                    height: 39.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '추가하기 +',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 120.w,
                    height: 39.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFC8C8C8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '건너뛰기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
