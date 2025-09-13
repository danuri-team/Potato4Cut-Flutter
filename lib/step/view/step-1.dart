import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:potato4cut/designSystem/font.dart';
import 'package:potato4cut/step/view/step-3.dart';

class Step1Page extends StatelessWidget {
  const Step1Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 52.w, vertical: 58.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/images/icons/close.svg'),
              SizedBox(height: 10.h),
              Align(
                child: Column(
                  children: [
                    Text(
                      '원하시는 프레임을 골라보세요',
                      style: AppTextStyle.pageTitleBold,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 70.h),
                    Container(
                      width: 200.w,
                      height: 360.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8.6,
                            offset: const Offset(6, 12),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/icons/official_frame.png',
                        width: 200.w,
                        height: 360.h,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text('미니감자 네컷', style: AppTextStyle.contentBold),
                    SizedBox(height: 6.h),
                    Text('너무귀여운감자띠', style: AppTextStyle.contentRegular),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Step3Page(),
                          ),
                        );
                      },
                      child: Container(
                        width: 120.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '선택하기',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
