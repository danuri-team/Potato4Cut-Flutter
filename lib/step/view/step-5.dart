import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato4cut/home/view/home_page.dart';
import 'package:potato4cut/step/view/text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Step5Page extends StatefulWidget {
  const Step5Page({
    required this.uuid,
    super.key,
  });
  final String uuid;

  @override
  State<Step5Page> createState() => _Step5PageState();
}

class _Step5PageState extends State<Step5Page> {
  // @override
  // void initState() {
  //   super.initState();
  //   deletePhoto();
  // }

  // Future<void> deletePhoto() async {
  //   final directory = await getTemporaryDirectory();
  //   await directory.delete(recursive: true);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 52.w,
          vertical: 58.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: SvgPicture.asset('assets/images/icons/close.svg'),
            ),
            SizedBox(height: 50.h),
            Align(
              child: SizedBox(
                width: 500.w,
                height: 500.h,
                child: QrImageView(
                  data: 'https://storage.danuri.cloud/potato-4-cut/${widget.uuid}.jpeg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
