import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:potato4cut/designSystem/font.dart';
import 'package:potato4cut/step/view/step-3.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(64, 52, 0, 0),
              child: Text(
                '감자\n네컷',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'HakgyoansimDunggeunmiso',
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 94),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 372.w,
                  height: 381.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 34.w, vertical: 34.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오리지널 네컷',
                        style: AppTextStyle.bannerBold
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '감자네컷 오리지널 프레임',
                        style: AppTextStyle.bannerRegular
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 176.w),
                        child: Image.asset(
                          'assets/images/character/demo-1.png',
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 70),
                // Container(
                //   width: 372.w,
                //   height: 381.h,
                //   decoration: BoxDecoration(
                //     color: Colors.black,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 34.h),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         '오리지널 네컷',
                //         style:
                //             AppTextStyle.bannerBold.copyWith(color: Colors.white),
                //       ),
                //       SizedBox(height: 6.h),
                //       Text('감자네컷 오리지널 프레임',
                //           style: AppTextStyle.bannerRegular
                //               .copyWith(color: Colors.white)),
                //     ],
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 40.h),
            Align(
              child: SizedBox(
                width: 110.w,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Step3Page(),
                      ),
                    );
                  },
                  child: const Text('시작하기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
